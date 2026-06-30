"""SMS delivery for OTP codes.

Two implementations:
- ConsoleSmsSender: dev/test fallback that logs instead of sending.
- Msg91SmsSender: posts to the MSG91 v5 OTP API in production.

get_sms_sender() picks based on settings; it is wired into the auth router as a
FastAPI dependency so tests can override it with a fake.
"""
import logging

import httpx

from app.config import settings

logger = logging.getLogger("janabala.sms")


class SmsError(Exception):
    """Raised when an SMS provider fails to accept a message."""


class BaseSmsSender:
    def send_otp(self, phone: str, otp: str) -> None:  # pragma: no cover - interface
        raise NotImplementedError


class ConsoleSmsSender(BaseSmsSender):
    """Logs the OTP instead of sending. Used when no provider is configured."""

    def send_otp(self, phone: str, otp: str) -> None:
        logger.info("ConsoleSmsSender: OTP for %s is %s", phone, otp)


class Msg91SmsSender(BaseSmsSender):
    def __init__(self, client: httpx.Client | None = None) -> None:
        self._client = client

    def _normalize(self, phone: str) -> str:
        # MSG91 expects the full international number without a leading '+'.
        digits = phone.lstrip("+").strip()
        if len(digits) <= 10:
            return f"{settings.SMS_DEFAULT_COUNTRY_CODE}{digits}"
        return digits

    def send_otp(self, phone: str, otp: str) -> None:
        if not settings.SMS_TEMPLATE_ID:
            raise SmsError("SMS_TEMPLATE_ID is not configured")

        url = f"{settings.SMS_BASE_URL}/otp"
        params = {
            "template_id": settings.SMS_TEMPLATE_ID,
            "mobile": self._normalize(phone),
            "authkey": settings.SMS_API_KEY,
            "otp": otp,
            "sender": settings.SMS_SENDER_ID,
        }
        client = self._client or httpx.Client(timeout=settings.SMS_TIMEOUT_SECONDS)
        try:
            resp = client.post(url, params=params)
        except httpx.HTTPError as exc:
            raise SmsError(f"MSG91 request failed: {exc}") from exc
        finally:
            if self._client is None:
                client.close()

        if resp.status_code != 200:
            raise SmsError(f"MSG91 returned HTTP {resp.status_code}: {resp.text}")
        # MSG91 returns {"type": "success", ...} on success, "error" otherwise.
        body = resp.json() if resp.content else {}
        if body.get("type") == "error":
            raise SmsError(f"MSG91 error: {body.get('message', resp.text)}")


def get_sms_sender() -> BaseSmsSender:
    if settings.SMS_PROVIDER == "msg91" and settings.SMS_API_KEY:
        return Msg91SmsSender()
    return ConsoleSmsSender()
