import uuid
from datetime import datetime

from pydantic import BaseModel

from app.schemas.issue import IssueCreate, IssueResponse


class SyncIssue(IssueCreate):
    # Client-generated id from the offline queue, so push is idempotent.
    client_id: uuid.UUID | None = None


class SyncPushRequest(BaseModel):
    issues: list[SyncIssue] = []


class SyncPushResponse(BaseModel):
    created: list[IssueResponse]
    count: int


class SyncPullResponse(BaseModel):
    issues: list[IssueResponse]
    server_time: datetime
    count: int
