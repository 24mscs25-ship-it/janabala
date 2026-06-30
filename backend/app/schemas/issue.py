import uuid
from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field

from app.schemas.enums import Category, Status, Urgency


class IssueCreate(BaseModel):
    category: Category
    title: str = Field(min_length=1, max_length=300)
    description: str | None = None
    constituency_id: uuid.UUID | None = None
    latitude: float | None = Field(default=None, ge=-90, le=90)
    longitude: float | None = Field(default=None, ge=-180, le=180)
    photo_urls: list[str] | None = None
    urgency: Urgency = Urgency.LOW


class IssueUpdate(BaseModel):
    category: Category | None = None
    title: str | None = Field(default=None, min_length=1, max_length=300)
    description: str | None = None
    latitude: float | None = Field(default=None, ge=-90, le=90)
    longitude: float | None = Field(default=None, ge=-180, le=180)
    photo_urls: list[str] | None = None
    urgency: Urgency | None = None
    status: Status | None = None


class IssueResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    user_id: uuid.UUID | None
    client_id: uuid.UUID | None
    constituency_id: uuid.UUID | None
    category: str
    title: str
    description: str | None
    latitude: float | None
    longitude: float | None
    photo_urls: list[str] | None
    urgency: str
    status: str
    created_at: datetime
    updated_at: datetime
