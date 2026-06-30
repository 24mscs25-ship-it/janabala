from app.config import settings
from tests.conftest import auth_headers


def test_full_otp_flow(client):
    r = client.post("/api/v1/auth/send-otp", json={"phone": "9000000001"})
    assert r.status_code == 200
    otp = r.json()["debug_otp"]
    assert otp and len(otp) == 6

    r = client.post(
        "/api/v1/auth/verify-otp", json={"phone": "9000000001", "otp": otp}
    )
    assert r.status_code == 200
    token = r.json()["access_token"]
    assert token

    r = client.get("/api/v1/auth/me", headers={"Authorization": f"Bearer {token}"})
    assert r.status_code == 200
    assert r.json()["phone"] == "9000000001"
    assert r.json()["is_verified"] is True


def test_verify_with_wrong_otp(client):
    client.post("/api/v1/auth/send-otp", json={"phone": "9000000002"})
    r = client.post(
        "/api/v1/auth/verify-otp", json={"phone": "9000000002", "otp": "000000"}
    )
    assert r.status_code == 400


def test_me_requires_auth(client):
    assert client.get("/api/v1/auth/me").status_code == 401
    bad = {"Authorization": "Bearer not-a-token"}
    assert client.get("/api/v1/auth/me", headers=bad).status_code == 401


def test_resend_cooldown(client):
    original = settings.OTP_RESEND_COOLDOWN_SECONDS
    settings.OTP_RESEND_COOLDOWN_SECONDS = 60
    try:
        r1 = client.post("/api/v1/auth/send-otp", json={"phone": "9000000003"})
        assert r1.status_code == 200
        r2 = client.post("/api/v1/auth/send-otp", json={"phone": "9000000003"})
        assert r2.status_code == 429
        assert "Retry-After" in r2.headers
    finally:
        settings.OTP_RESEND_COOLDOWN_SECONDS = original


def test_resend_invalidates_old_otp(client):
    old = client.post(
        "/api/v1/auth/send-otp", json={"phone": "9000000004"}
    ).json()["debug_otp"]
    new = client.post(
        "/api/v1/auth/send-otp", json={"phone": "9000000004"}
    ).json()["debug_otp"]
    assert old != new

    # The superseded OTP must no longer work.
    r = client.post(
        "/api/v1/auth/verify-otp", json={"phone": "9000000004", "otp": old}
    )
    assert r.status_code == 400

    r = client.post(
        "/api/v1/auth/verify-otp", json={"phone": "9000000004", "otp": new}
    )
    assert r.status_code == 200


def test_attempt_cap_locks_otp(client):
    correct = client.post(
        "/api/v1/auth/send-otp", json={"phone": "9000000005"}
    ).json()["debug_otp"]

    # Exhaust the attempt cap with wrong guesses (avoid colliding with the real OTP).
    wrong = "111111" if correct != "111111" else "222222"
    for _ in range(settings.OTP_MAX_ATTEMPTS):
        r = client.post(
            "/api/v1/auth/verify-otp", json={"phone": "9000000005", "otp": wrong}
        )
        assert r.status_code == 400

    # Even the correct OTP is now locked out until a new one is requested.
    r = client.post(
        "/api/v1/auth/verify-otp", json={"phone": "9000000005", "otp": correct}
    )
    assert r.status_code == 429
