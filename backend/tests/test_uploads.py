import pytest

from app.config import settings
from app.storage import UPLOAD_ROOT
from tests.conftest import auth_headers

PNG_BYTES = b"\x89PNG\r\n\x1a\n" + b"\x00" * 32


@pytest.fixture()
def cleanup_uploads():
    """Remove any files a test creates in the real upload dir."""
    before = set(UPLOAD_ROOT.iterdir()) if UPLOAD_ROOT.exists() else set()
    yield
    after = set(UPLOAD_ROOT.iterdir()) if UPLOAD_ROOT.exists() else set()
    for path in after - before:
        path.unlink(missing_ok=True)


def test_upload_requires_auth(client):
    r = client.post(
        "/api/v1/uploads", files={"file": ("p.png", PNG_BYTES, "image/png")}
    )
    assert r.status_code == 401


def test_upload_image_returns_url(client, cleanup_uploads):
    headers = auth_headers(client)
    r = client.post(
        "/api/v1/uploads",
        files={"file": ("p.png", PNG_BYTES, "image/png")},
        headers=headers,
    )
    assert r.status_code == 201
    body = r.json()
    assert body["url"].startswith(settings.UPLOAD_URL_PREFIX + "/")
    assert body["filename"].endswith(".png")
    # File actually persisted to disk.
    assert (UPLOAD_ROOT / body["filename"]).exists()


def test_upload_rejects_non_image(client):
    headers = auth_headers(client)
    r = client.post(
        "/api/v1/uploads",
        files={"file": ("note.txt", b"hello", "text/plain")},
        headers=headers,
    )
    assert r.status_code == 415


def test_upload_rejects_oversized(client, monkeypatch, cleanup_uploads):
    monkeypatch.setattr(settings, "UPLOAD_MAX_BYTES", 10)
    headers = auth_headers(client)
    r = client.post(
        "/api/v1/uploads",
        files={"file": ("big.png", b"x" * 50, "image/png")},
        headers=headers,
    )
    assert r.status_code == 413


def test_uploaded_file_is_retrievable(client, cleanup_uploads):
    headers = auth_headers(client)
    up = client.post(
        "/api/v1/uploads",
        files={"file": ("p.png", PNG_BYTES, "image/png")},
        headers=headers,
    ).json()

    r = client.get(up["url"])
    assert r.status_code == 200
    assert r.content == PNG_BYTES
