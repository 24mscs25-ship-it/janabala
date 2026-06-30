from fastapi import APIRouter, Depends, Query
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.database import get_db
from app.models import Constituency
from app.schemas.constituency import ConstituencyResponse

router = APIRouter()


@router.get("", response_model=list[ConstituencyResponse])
def list_constituencies(
    q: str | None = Query(None, description="Case-insensitive name/code search"),
    db: Session = Depends(get_db),
):
    stmt = select(Constituency)
    if q:
        like = f"%{q}%"
        stmt = stmt.where(
            Constituency.name.ilike(like) | Constituency.code.ilike(like)
        )
    stmt = stmt.order_by(Constituency.name.asc())
    return list(db.scalars(stmt).all())
