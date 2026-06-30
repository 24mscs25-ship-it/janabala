import secrets
from datetime import datetime, timedelta, timezone

from jose import JWTError, jwt

from app.config import settings


def generate_otp(length: int | None = None) -> str:
    n = length or settings.OTP_LENGTH
    return "".join(str(secrets.randbelow(10)) for _ in range(n))


def create_access_token(subject: str, expires_minutes: int | None = None) -> str:
    minutes = expires_minutes or settings.ACCESS_TOKEN_EXPIRE_MINUTES
    expire = datetime.now(timezone.utc) + timedelta(minutes=minutes)
    payload = {"sub": subject, "exp": expire}
    return jwt.encode(payload, settings.SECRET_KEY, algorithm=settings.ALGORITHM)


def decode_token(token: str) -> str | None:
    """Return the subject (user id) or None if the token is invalid/expired."""
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
    except JWTError:
        return None
    return payload.get("sub")
