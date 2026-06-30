import uuid
from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field


class SendOtpRequest(BaseModel):
    phone: str = Field(min_length=10, max_length=15)


class SendOtpResponse(BaseModel):
    message: str
    # Only populated when DEBUG=True so local testing needs no SMS provider.
    debug_otp: str | None = None


class VerifyOtpRequest(BaseModel):
    phone: str = Field(min_length=10, max_length=15)
    otp: str = Field(min_length=4, max_length=6)


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"


class UserResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    phone: str
    name: str | None
    constituency_id: uuid.UUID | None
    role: str
    is_verified: bool
    created_at: datetime
