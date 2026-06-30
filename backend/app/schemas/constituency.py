import uuid
from datetime import datetime

from pydantic import BaseModel, ConfigDict


class ConstituencyResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    name: str
    code: str
    district: str | None
    state: str
    created_at: datetime
