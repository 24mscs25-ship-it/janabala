import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from app.config import settings
from app.database import Base, get_db
from app.main import app

# Tests rely on the dev OTP echo, which only fires in DEBUG mode.
settings.DEBUG = True
# Disable the resend cooldown by default so helpers that send per-phase aren't
# throttled; the dedicated cooldown test re-enables it locally.
settings.OTP_RESEND_COOLDOWN_SECONDS = 0


@pytest.fixture()
def _engine(tmp_path):
    db_url = f"sqlite:///{tmp_path / 'test.db'}"
    engine = create_engine(db_url, connect_args={"check_same_thread": False})
    Base.metadata.create_all(bind=engine)
    yield engine
    Base.metadata.drop_all(bind=engine)
    engine.dispose()


@pytest.fixture()
def _session_factory(_engine):
    return sessionmaker(autocommit=False, autoflush=False, bind=_engine)


@pytest.fixture()
def client(_session_factory):
    def override_get_db():
        db = _session_factory()
        try:
            yield db
        finally:
            db.close()

    app.dependency_overrides[get_db] = override_get_db
    with TestClient(app) as c:
        yield c
    app.dependency_overrides.clear()


@pytest.fixture()
def db_session(_session_factory):
    db = _session_factory()
    try:
        yield db
    finally:
        db.close()


def auth_headers(client, phone="9876543210"):
    """Run the OTP flow and return Authorization headers for a verified user."""
    r = client.post("/api/v1/auth/send-otp", json={"phone": phone})
    otp = r.json()["debug_otp"]
    r = client.post("/api/v1/auth/verify-otp", json={"phone": phone, "otp": otp})
    token = r.json()["access_token"]
    return {"Authorization": f"Bearer {token}"}
