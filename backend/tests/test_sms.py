import httpx
import pytest

from app.config import settings
from app.core.sms import (
    ConsoleSmsSender,
    Msg91SmsSender,
    SmsError,
    get_sms_sender,
)
from app.main import app


class FakeSender(ConsoleSmsSender):
    def __init__(self):
        self.calls = []

    def send_otp(self, phone, otp):
        self.calls.append((phone, otp))


class FailingSender(ConsoleSmsSender):
    def send_otp(self, phone, otp):
        raise SmsError("provider down")


def test_send_otp_invokes_sender(client):
    fake = FakeSender()
    app.dependency_overrides[get_sms_sender] = lambda: fake
    try:
        r = client.post("/api/v1/auth/send-otp", json={"phone": "9000100001"})
        assert r.status_code == 200
        assert len(fake.calls) == 1
        phone, otp = fake.calls[0]
        assert phone == "9000100001"
        # The delivered OTP matches the one echoed in DEBUG mode.
        assert otp == r.json()["debug_otp"]
    finally:
        app.dependency_overrides.pop(get_sms_sender, None)


def test_send_otp_delivery_failure_returns_502(client):
    app.dependency_overrides[get_sms_sender] = lambda: FailingSender()
    try:
        r = client.post("/api/v1/auth/send-otp", json={"phone": "9000100002"})
        assert r.status_code == 502
    finally:
        app.dependency_overrides.pop(get_sms_sender, None)


def test_failed_delivery_persists_no_otp(client):
    # A failed send must not create an OtpSession (so retry isn't cooldown-blocked).
    app.dependency_overrides[get_sms_sender] = lambda: FailingSender()
    try:
        client.post("/api/v1/auth/send-otp", json={"phone": "9000100003"})
    finally:
        app.dependency_overrides.pop(get_sms_sender, None)

    # A subsequent successful send (default console sender) should work immediately.
    r = client.post("/api/v1/auth/send-otp", json={"phone": "9000100003"})
    assert r.status_code == 200


def test_factory_selects_console_without_key():
    assert isinstance(get_sms_sender(), ConsoleSmsSender)


def test_msg91_builds_request_without_network(monkeypatch):
    monkeypatch.setattr(settings, "SMS_TEMPLATE_ID", "tmpl_123")
    monkeypatch.setattr(settings, "SMS_API_KEY", "secret-key")

    captured = {}

    def handler(request: httpx.Request) -> httpx.Response:
        captured["url"] = str(request.url)
        return httpx.Response(200, json={"type": "success", "message": "sent"})

    transport = httpx.MockTransport(handler)
    sender = Msg91SmsSender(client=httpx.Client(transport=transport))
    sender.send_otp("9876543210", "123456")

    url = captured["url"]
    assert url.startswith(f"{settings.SMS_BASE_URL}/otp")
    assert "template_id=tmpl_123" in url
    assert "authkey=secret-key" in url
    assert "otp=123456" in url
    # 10-digit number gets the default country code prefixed.
    assert "mobile=919876543210" in url


def test_msg91_raises_on_error_response(monkeypatch):
    monkeypatch.setattr(settings, "SMS_TEMPLATE_ID", "tmpl_123")

    def handler(request: httpx.Request) -> httpx.Response:
        return httpx.Response(200, json={"type": "error", "message": "bad template"})

    sender = Msg91SmsSender(client=httpx.Client(transport=httpx.MockTransport(handler)))
    with pytest.raises(SmsError):
        sender.send_otp("9876543210", "123456")
