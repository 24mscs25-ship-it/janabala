from tests.conftest import auth_headers


def _make_issue(client, headers, **overrides):
    payload = {"category": "ROADS", "title": "Pothole on MG Road", "urgency": "HIGH"}
    payload.update(overrides)
    return client.post("/api/v1/issues", json=payload, headers=headers)


def test_create_requires_auth(client):
    assert _make_issue(client, {}).status_code == 401


def test_create_and_get_issue(client):
    headers = auth_headers(client)
    r = _make_issue(client, headers)
    assert r.status_code == 201
    issue = r.json()
    assert issue["category"] == "ROADS"
    assert issue["status"] == "open"

    r = client.get(f"/api/v1/issues/{issue['id']}")
    assert r.status_code == 200
    assert r.json()["title"] == "Pothole on MG Road"


def test_list_and_filter(client):
    headers = auth_headers(client)
    _make_issue(client, headers, category="ROADS", title="A")
    _make_issue(client, headers, category="WATER", title="B")

    r = client.get("/api/v1/issues")
    assert r.status_code == 200
    assert len(r.json()) == 2

    r = client.get("/api/v1/issues", params={"category": "WATER"})
    assert [i["category"] for i in r.json()] == ["WATER"]


def test_invalid_category_rejected(client):
    headers = auth_headers(client)
    assert _make_issue(client, headers, category="NONSENSE").status_code == 422


def test_owner_can_update_other_cannot(client):
    owner = auth_headers(client, phone="9111111111")
    other = auth_headers(client, phone="9222222222")
    issue_id = _make_issue(client, owner).json()["id"]

    r = client.put(
        f"/api/v1/issues/{issue_id}", json={"status": "resolved"}, headers=owner
    )
    assert r.status_code == 200
    assert r.json()["status"] == "resolved"

    r = client.put(
        f"/api/v1/issues/{issue_id}", json={"title": "hijack"}, headers=other
    )
    assert r.status_code == 403


def test_delete_requires_admin(client):
    headers = auth_headers(client)
    issue_id = _make_issue(client, headers).json()["id"]
    # Citizen (default role) cannot delete.
    assert client.delete(f"/api/v1/issues/{issue_id}", headers=headers).status_code == 403
