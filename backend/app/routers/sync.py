import uuid
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, Query
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.database import get_db
from app.deps import get_current_user
from app.models import Issue, User
from app.schemas.sync import SyncPullResponse, SyncPushRequest, SyncPushResponse

router = APIRouter()


@router.post("/push", response_model=SyncPushResponse)
def sync_push(
    body: SyncPushRequest,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    # Returns one issue per pushed item (new or pre-existing) so an offline client
    # can reconcile its queue. Items carrying a client_id are deduped on
    # (user_id, client_id), making repeated pushes idempotent.
    results = []
    seen: dict[uuid.UUID, Issue] = {}
    for item in body.issues:
        if item.client_id is not None:
            if item.client_id in seen:
                results.append(seen[item.client_id])
                continue
            existing = db.scalars(
                select(Issue).where(
                    Issue.user_id == user.id, Issue.client_id == item.client_id
                )
            ).first()
            if existing is not None:
                seen[item.client_id] = existing
                results.append(existing)
                continue

        issue = Issue(
            user_id=user.id,
            client_id=item.client_id,
            constituency_id=item.constituency_id or user.constituency_id,
            category=item.category.value,
            title=item.title,
            description=item.description,
            latitude=item.latitude,
            longitude=item.longitude,
            photo_urls=item.photo_urls,
            urgency=item.urgency.value,
            status="open",
        )
        db.add(issue)
        if item.client_id is not None:
            seen[item.client_id] = issue
        results.append(issue)

    db.commit()
    for issue in results:
        db.refresh(issue)
    return SyncPushResponse(created=results, count=len(results))


@router.get("/pull", response_model=SyncPullResponse)
def sync_pull(
    since: datetime | None = Query(None),
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    stmt = select(Issue)
    if since is not None:
        stmt = stmt.where(Issue.updated_at > since)
    stmt = stmt.order_by(Issue.updated_at.asc())
    issues = list(db.scalars(stmt).all())
    return SyncPullResponse(
        issues=issues,
        server_time=datetime.now(timezone.utc),
        count=len(issues),
    )
