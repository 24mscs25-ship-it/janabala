from datetime import datetime, timedelta, timezone
import logging

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import delete, select
from sqlalchemy.orm import Session

from app.config import settings
from app.core.security import create_access_token, generate_otp
from app.core.sms import BaseSmsSender, SmsError, get_sms_sender
from app.database import get_db
from app.deps import get_current_user
from app.models import OtpSession, User
from app.schemas.auth import (
    SendOtpRequest,
    SendOtpResponse,
    TokenResponse,
    UserResponse,
    VerifyOtpRequest,
)

router = APIRouter()
logger = logging.getLogger("janabala.auth")


@router.post("/send-otp", response_model=SendOtpResponse)
def send_otp(
    body: SendOtpRequest,
    db: Session = Depends(get_db),
    sms: BaseSmsSender = Depends(get_sms_sender),
):
    now = datetime.now(timezone.utc)

    # Cooldown: reject rapid resends for the same phone.
    latest = db.scalars(
        select(OtpSession)
        .where(OtpSession.phone == body.phone, OtpSession.verified.is_(False))
        .order_by(OtpSession.created_at.desc())
    ).first()
    if latest is not None:
        age = (now - _as_utc(latest.created_at)).total_seconds()
        if age < settings.OTP_RESEND_COOLDOWN_SECONDS:
            retry_in = int(settings.OTP_RESEND_COOLDOWN_SECONDS - age)
            raise HTTPException(
                status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                detail=f"Please wait {retry_in}s before requesting another OTP",
                headers={"Retry-After": str(retry_in)},
            )

    otp = generate_otp()

    # Deliver first; if the provider rejects it we don't persist anything, so the
    # cooldown won't block an immediate retry and no stale OTP lingers.
    try:
        sms.send_otp(body.phone, otp)
    except SmsError as exc:
        logger.error("OTP delivery failed for %s: %s", body.phone, exc)
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail="Failed to send OTP. Please try again.",
        )

    # Invalidate prior unverified OTPs so only the newest one is usable.
    db.execute(
        delete(OtpSession).where(
            OtpSession.phone == body.phone, OtpSession.verified.is_(False)
        )
    )

    expires_at = now + timedelta(seconds=settings.OTP_EXPIRE_SECONDS)
    db.add(OtpSession(phone=body.phone, otp=otp, expires_at=expires_at))
    db.commit()

    # Echo the OTP only in DEBUG so local testing needs no real SMS provider.
    debug_otp = otp if settings.DEBUG else None
    return SendOtpResponse(message="OTP sent", debug_otp=debug_otp)


@router.post("/verify-otp", response_model=TokenResponse)
def verify_otp(body: VerifyOtpRequest, db: Session = Depends(get_db)):
    now = datetime.now(timezone.utc)

    # Look up by phone (not phone+otp) so a wrong guess still counts as an attempt.
    session = db.scalars(
        select(OtpSession)
        .where(OtpSession.phone == body.phone, OtpSession.verified.is_(False))
        .order_by(OtpSession.created_at.desc())
    ).first()

    if session is None or _expired(session.expires_at, now):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid or expired OTP"
        )

    if session.attempts >= settings.OTP_MAX_ATTEMPTS:
        raise HTTPException(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail="Too many attempts. Request a new OTP.",
        )

    if session.otp != body.otp:
        session.attempts += 1
        db.commit()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid or expired OTP"
        )

    session.verified = True

    user = db.scalars(select(User).where(User.phone == body.phone)).first()
    if user is None:
        user = User(phone=body.phone, is_verified=True)
        db.add(user)
    else:
        user.is_verified = True
        user.last_active = now
    db.commit()
    db.refresh(user)

    token = create_access_token(subject=str(user.id))
    return TokenResponse(access_token=token)


@router.get("/me", response_model=UserResponse)
def me(user: User = Depends(get_current_user)):
    return user


def _as_utc(dt: datetime) -> datetime:
    # SQLite returns naive datetimes; treat them as UTC.
    return dt if dt.tzinfo is not None else dt.replace(tzinfo=timezone.utc)


def _expired(expires_at: datetime, now: datetime) -> bool:
    return _as_utc(expires_at) < now
