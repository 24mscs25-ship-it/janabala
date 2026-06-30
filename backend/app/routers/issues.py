import uuid
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.database import get_db
from app.deps import get_current_admin, get_current_user
from app.models import Issue, User
from app.schemas.enums import Category, Status
from app.schemas.issue import IssueCreate, IssueResponse, IssueUpdate

router = APIRouter()


@router.get("", response_model=list[IssueResponse])
def list_issues(
    constituency_id: uuid.UUID | None = Query(None),
    category: Category | None = Query(None),
    status: Status | None = Query(None),
    limit: int = Query(50, ge=1, le=100),
    offset: int = Query(0, ge=0),
    db: Session = Depends(get_db),
):
    stmt = select(Issue)
    if constituency_id is not None:
        stmt = stmt.where(Issue.constituency_id == constituency_id)
    if category is not None:
        stmt = stmt.where(Issue.category == category.value)
    if status is not None:
        stmt = stmt.where(Issue.status == status.value)
    stmt = stmt.order_by(Issue.created_at.desc()).limit(limit).offset(offset)
    return list(db.scalars(stmt).all())


@router.get("/{issue_id}", response_model=IssueResponse)
def get_issue(issue_id: uuid.UUID, db: Session = Depends(get_db)):
    issue = db.get(Issue, issue_id)
    if issue is None:
        raise HTTPException(status_code=404, detail="Issue not found")
    return issue


@router.post("", response_model=IssueResponse, status_code=201)
def create_issue(
    body: IssueCreate,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    issue = Issue(
        user_id=user.id,
        constituency_id=body.constituency_id or user.constituency_id,
        category=body.category.value,
        title=body.title,
        description=body.description,
        latitude=body.latitude,
        longitude=body.longitude,
        photo_urls=body.photo_urls,
        urgency=body.urgency.value,
        status="open",
    )
    db.add(issue)
    db.commit()
    db.refresh(issue)
    return issue


@router.put("/{issue_id}", response_model=IssueResponse)
def update_issue(
    issue_id: uuid.UUID,
    body: IssueUpdate,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    issue = db.get(Issue, issue_id)
    if issue is None:
        raise HTTPException(status_code=404, detail="Issue not found")

    # Only the reporter or an admin may edit.
    if issue.user_id != user.id and user.role != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Not allowed to edit this issue"
        )

    data = body.model_dump(exclude_unset=True)
    for field in ("category", "urgency", "status"):
        if data.get(field) is not None:
            data[field] = data[field].value
    for key, value in data.items():
        setattr(issue, key, value)

    if data.get("status") == "resolved" and issue.resolved_at is None:
        issue.resolved_at = datetime.now(timezone.utc)

    db.commit()
    db.refresh(issue)
    return issue


@router.delete("/{issue_id}", status_code=204)
def delete_issue(
    issue_id: uuid.UUID,
    db: Session = Depends(get_db),
    admin: User = Depends(get_current_admin),
):
    issue = db.get(Issue, issue_id)
    if issue is None:
        raise HTTPException(status_code=404, detail="Issue not found")
    db.delete(issue)
    db.commit()
