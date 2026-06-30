import logging

from fastapi.testclient import TestClient

from app.core.logging_config import JsonFormatter
from app.main import app


def test_json_formatter_emits_structured_fields():
    import json

    record = logging.LogRecord(
        name="janabala.test",
        level=logging.INFO,
        pathname=__file__,
        lineno=1,
        msg="hello",
        args=(),
        exc_info=None,
    )
    record.request_id = "abc123"
    record.status_code = 200

    out = json.loads(JsonFormatter().format(record))
    assert out["level"] == "INFO"
    assert out["logger"] == "janabala.test"
    assert out["message"] == "hello"
    # Fields attached via `extra=` are merged into the JSON payload.
    assert out["request_id"] == "abc123"
    assert out["status_code"] == 200


def test_unhandled_exception_returns_clean_500():
    @app.get("/api/v1/_boom")
    def _boom():
        raise RuntimeError("kaboom: secret stack detail")

    try:
        # raise_server_exceptions=False so the handler's response surfaces.
        with TestClient(app, raise_server_exceptions=False) as c:
            r = c.get("/api/v1/_boom")
        assert r.status_code == 500
        assert r.json() == {"detail": "Internal server error"}
        # The exception message must not leak to the client.
        assert "kaboom" not in r.text
    finally:
        app.router.routes = [
            route
            for route in app.router.routes
            if getattr(route, "path", None) != "/api/v1/_boom"
        ]


def test_request_id_header_roundtrips(client):
    r = client.get("/api/v1/health")
    assert r.status_code == 200
    assert r.headers.get("X-Request-ID")

    r = client.get("/api/v1/health", headers={"X-Request-ID": "trace-42"})
    assert r.headers.get("X-Request-ID") == "trace-42"
