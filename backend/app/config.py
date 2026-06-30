from typing import List

from pydantic import field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    APP_NAME: str = "JanaBala API"
    DEBUG: bool = False

    DATABASE_URL: str = "sqlite:///./janabala.db"

    SECRET_KEY: str = "change-me-in-production"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7

    # Stored as a string in env (comma-separated) to avoid pydantic-settings'
    # JSON parsing of complex types; exposed as a list via cors_origins_list.
    CORS_ORIGINS: str = "http://localhost:3000,http://localhost:8080"

    OTP_LENGTH: int = 6
    OTP_EXPIRE_SECONDS: int = 300
    # Min seconds between send-otp requests for the same phone.
    OTP_RESEND_COOLDOWN_SECONDS: int = 60
    # Max wrong verify attempts before an OTP is locked.
    OTP_MAX_ATTEMPTS: int = 5

    SMS_PROVIDER: str = "msg91"
    SMS_API_KEY: str = ""
    # MSG91-specific. SMS_TEMPLATE_ID is the approved OTP template (DLT).
    SMS_SENDER_ID: str = "JANBAL"
    SMS_TEMPLATE_ID: str = ""
    SMS_DEFAULT_COUNTRY_CODE: str = "91"
    SMS_BASE_URL: str = "https://control.msg91.com/api/v5"
    SMS_TIMEOUT_SECONDS: float = 10.0

    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    @field_validator("CORS_ORIGINS")
    @classmethod
    def _strip(cls, v: str) -> str:
        return v.strip()

    @property
    def cors_origins_list(self) -> List[str]:
        return [o.strip() for o in self.CORS_ORIGINS.split(",") if o.strip()]

    @property
    def is_sqlite(self) -> bool:
        return self.DATABASE_URL.startswith("sqlite")


settings = Settings()
