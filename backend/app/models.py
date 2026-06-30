import uuid
from datetime import datetime, timezone

from sqlalchemy import (
    JSON,
    Boolean,
    DateTime,
    ForeignKey,
    Index,
    Numeric,
    String,
    Text,
    UniqueConstraint,
    Uuid,
)
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


def _uuid() -> uuid.UUID:
    return uuid.uuid4()


def _now() -> datetime:
    return datetime.now(timezone.utc)


class Constituency(Base):
    __tablename__ = "constituencies"

    id: Mapped[uuid.UUID] = mapped_column(Uuid, primary_key=True, default=_uuid)
    name: Mapped[str] = mapped_column(String(200), nullable=False)
    code: Mapped[str] = mapped_column(String(50), unique=True, nullable=False)
    district: Mapped[str | None] = mapped_column(String(200))
    state: Mapped[str] = mapped_column(String(100), default="Karnataka")
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=_now)


class User(Base):
    __tablename__ = "users"

    id: Mapped[uuid.UUID] = mapped_column(Uuid, primary_key=True, default=_uuid)
    phone: Mapped[str] = mapped_column(String(15), unique=True, nullable=False)
    name: Mapped[str | None] = mapped_column(String(200))
    constituency_id: Mapped[uuid.UUID | None] = mapped_column(
        Uuid, ForeignKey("constituencies.id")
    )
    role: Mapped[str] = mapped_column(String(50), default="citizen")
    is_verified: Mapped[bool] = mapped_column(Boolean, default=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=_now)
    last_active: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=_now)


class OtpSession(Base):
    __tablename__ = "otp_sessions"

    id: Mapped[uuid.UUID] = mapped_column(Uuid, primary_key=True, default=_uuid)
    phone: Mapped[str] = mapped_column(String(15), nullable=False)
    otp: Mapped[str] = mapped_column(String(6), nullable=False)
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    verified: Mapped[bool] = mapped_column(Boolean, default=False)
    attempts: Mapped[int] = mapped_column(default=0, nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=_now)


class Issue(Base):
    __tablename__ = "issues"

    id: Mapped[uuid.UUID] = mapped_column(Uuid, primary_key=True, default=_uuid)
    user_id: Mapped[uuid.UUID | None] = mapped_column(Uuid, ForeignKey("users.id"))
    # Client-generated id from an offline queue; makes sync/push idempotent.
    client_id: Mapped[uuid.UUID | None] = mapped_column(Uuid)
    constituency_id: Mapped[uuid.UUID | None] = mapped_column(
        Uuid, ForeignKey("constituencies.id")
    )
    category: Mapped[str] = mapped_column(String(50), nullable=False)
    title: Mapped[str] = mapped_column(String(300), nullable=False)
    description: Mapped[str | None] = mapped_column(Text)
    latitude: Mapped[float | None] = mapped_column(Numeric(10, 7))
    longitude: Mapped[float | None] = mapped_column(Numeric(10, 7))
    photo_urls: Mapped[list | None] = mapped_column(JSON)
    urgency: Mapped[str] = mapped_column(String(10), default="LOW")
    status: Mapped[str] = mapped_column(String(20), default="open")
    assigned_to: Mapped[uuid.UUID | None] = mapped_column(Uuid, ForeignKey("users.id"))
    resolved_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=_now)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=_now, onupdate=_now
    )

    __table_args__ = (
        Index("idx_issues_constituency", "constituency_id"),
        Index("idx_issues_status", "status"),
        Index("idx_issues_category", "category"),
        Index("idx_issues_created", "created_at"),
        # A client_id is unique per user, so re-pushing a queued issue is a no-op.
        UniqueConstraint("user_id", "client_id", name="uq_issues_user_client"),
    )


class SyncLog(Base):
    __tablename__ = "sync_log"

    id: Mapped[uuid.UUID] = mapped_column(Uuid, primary_key=True, default=_uuid)
    user_id: Mapped[uuid.UUID | None] = mapped_column(Uuid, ForeignKey("users.id"))
    entity_type: Mapped[str] = mapped_column(String(50), nullable=False)
    entity_id: Mapped[uuid.UUID] = mapped_column(Uuid, nullable=False)
    action: Mapped[str] = mapped_column(String(20), nullable=False)
    payload: Mapped[dict | None] = mapped_column(JSON)
    synced_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=_now)

    __table_args__ = (
        Index("idx_sync_user", "user_id"),
        Index("idx_sync_status", "synced_at"),
    )
