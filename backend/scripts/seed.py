"""Seed a sample set of Karnataka assembly constituencies.

Idempotent: skips constituencies whose code already exists. Run after
`alembic upgrade head`:

    python scripts/seed.py
"""
import sys
from pathlib import Path

sys.path.append(str(Path(__file__).resolve().parent.parent))

from sqlalchemy import select

from app.database import SessionLocal
from app.models import Constituency

# A representative sample; the full Phase 1 target is all 224 constituencies.
CONSTITUENCIES = [
    {"name": "Bengaluru South", "code": "KA-BLR-S", "district": "Bengaluru Urban"},
    {"name": "Bengaluru North", "code": "KA-BLR-N", "district": "Bengaluru Urban"},
    {"name": "Bengaluru Central", "code": "KA-BLR-C", "district": "Bengaluru Urban"},
    {"name": "Mysuru", "code": "KA-MYS", "district": "Mysuru"},
    {"name": "Mangaluru", "code": "KA-MNG", "district": "Dakshina Kannada"},
    {"name": "Hubballi-Dharwad", "code": "KA-HBL", "district": "Dharwad"},
    {"name": "Belagavi", "code": "KA-BGM", "district": "Belagavi"},
    {"name": "Kalaburagi", "code": "KA-KLB", "district": "Kalaburagi"},
    {"name": "Ballari", "code": "KA-BLY", "district": "Ballari"},
    {"name": "Tumakuru", "code": "KA-TMK", "district": "Tumakuru"},
]


def seed() -> None:
    db = SessionLocal()
    try:
        added = 0
        for row in CONSTITUENCIES:
            exists = db.scalars(
                select(Constituency).where(Constituency.code == row["code"])
            ).first()
            if exists:
                continue
            db.add(Constituency(**row))
            added += 1
        db.commit()
        print(f"Seed complete: {added} added, {len(CONSTITUENCIES) - added} skipped.")
    finally:
        db.close()


if __name__ == "__main__":
    seed()
