from app.models import Constituency


def test_list_empty(client):
    r = client.get("/api/v1/constituencies")
    assert r.status_code == 200
    assert r.json() == []


def test_list_and_search(client, db_session):
    db_session.add_all(
        [
            Constituency(name="Bengaluru South", code="KA-BLR-S", district="Bengaluru Urban"),
            Constituency(name="Mysuru", code="KA-MYS", district="Mysuru"),
        ]
    )
    db_session.commit()

    r = client.get("/api/v1/constituencies")
    assert r.status_code == 200
    body = r.json()
    assert len(body) == 2
    # Ordered by name ascending.
    assert [c["name"] for c in body] == ["Bengaluru South", "Mysuru"]
    assert set(body[0].keys()) >= {"id", "name", "code", "district", "state"}

    r = client.get("/api/v1/constituencies", params={"q": "mys"})
    assert [c["code"] for c in r.json()] == ["KA-MYS"]

    r = client.get("/api/v1/constituencies", params={"q": "KA-BLR"})
    assert [c["name"] for c in r.json()] == ["Bengaluru South"]
