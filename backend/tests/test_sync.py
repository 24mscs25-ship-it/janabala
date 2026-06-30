from tests.conftest import auth_headers


def test_sync_push_creates_issues(client):
    headers = auth_headers(client)
    payload = {
        "issues": [
            {"category": "WATER", "title": "Leak near well", "urgency": "MEDIUM"},
            {"category": "STREETLIGHT", "title": "Dark lane", "urgency": "LOW"},
        ]
    }
    r = client.post("/api/v1/sync/push", json=payload, headers=headers)
    assert r.status_code == 200
    body = r.json()
    assert body["count"] == 2
    assert len(body["created"]) == 2


def test_sync_push_requires_auth(client):
    assert client.post("/api/v1/sync/push", json={"issues": []}).status_code == 401


def test_sync_pull_returns_issues(client):
    headers = auth_headers(client)
    client.post(
        "/api/v1/issues",
        json={"category": "ROADS", "title": "X", "urgency": "LOW"},
        headers=headers,
    )
    r = client.get("/api/v1/sync/pull", headers=headers)
    assert r.status_code == 200
    body = r.json()
    assert body["count"] == 1
    assert "server_time" in body


def test_sync_pull_since_filters(client):
    headers = auth_headers(client)
    client.post(
        "/api/v1/issues",
        json={"category": "ROADS", "title": "X", "urgency": "LOW"},
        headers=headers,
    )
    # A far-future timestamp should exclude everything.
    r = client.get(
        "/api/v1/sync/pull", params={"since": "2999-01-01T00:00:00+00:00"}, headers=headers
    )
    assert r.json()["count"] == 0


def test_push_is_idempotent_on_client_id(client):
    headers = auth_headers(client)
    cid = "11111111-1111-1111-1111-111111111111"
    item = {
        "client_id": cid,
        "category": "WATER",
        "title": "Queued offline",
        "urgency": "LOW",
    }

    first = client.post("/api/v1/sync/push", json={"issues": [item]}, headers=headers)
    assert first.status_code == 200
    issue_id = first.json()["created"][0]["id"]
    assert first.json()["created"][0]["client_id"] == cid

    # Re-pushing the same client_id must not create a duplicate.
    second = client.post("/api/v1/sync/push", json={"issues": [item]}, headers=headers)
    assert second.json()["created"][0]["id"] == issue_id

    # Only one issue exists for this user.
    assert len(client.get("/api/v1/issues").json()) == 1


def test_duplicate_client_id_within_one_batch(client):
    headers = auth_headers(client)
    cid = "22222222-2222-2222-2222-222222222222"
    item = {"client_id": cid, "category": "ROADS", "title": "Dup", "urgency": "LOW"}

    r = client.post(
        "/api/v1/sync/push", json={"issues": [item, item]}, headers=headers
    )
    body = r.json()
    # Both entries map to the same created issue; no duplicate persisted.
    assert body["created"][0]["id"] == body["created"][1]["id"]
    assert len(client.get("/api/v1/issues").json()) == 1


def test_push_without_client_id_always_creates(client):
    headers = auth_headers(client)
    item = {"category": "ROADS", "title": "No id", "urgency": "LOW"}
    client.post("/api/v1/sync/push", json={"issues": [item]}, headers=headers)
    client.post("/api/v1/sync/push", json={"issues": [item]}, headers=headers)
    # Without a client_id there's no dedup key, so two issues are created.
    assert len(client.get("/api/v1/issues").json()) == 2


def test_same_client_id_distinct_users_are_separate(client):
    cid = "33333333-3333-3333-3333-333333333333"
    item = {"client_id": cid, "category": "WATER", "title": "Mine", "urgency": "LOW"}

    user_a = auth_headers(client, phone="9333000001")
    user_b = auth_headers(client, phone="9333000002")

    client.post("/api/v1/sync/push", json={"issues": [item]}, headers=user_a)
    client.post("/api/v1/sync/push", json={"issues": [item]}, headers=user_b)
    # client_id is unique per user, so each user gets their own issue.
    assert len(client.get("/api/v1/issues").json()) == 2
