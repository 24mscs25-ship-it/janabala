# JanaBala (ಜನಬಲ) — Prajakeeya

Digital democracy platform for citizen-government engagement. **Status: Phase 1 backend implemented** — a working civic issue-reporting API (OTP auth, issues CRUD, offline sync) is in place. The mobile app and web dashboard are still to come (see "Current state" below).

**Author:** Yeshwanth C R (ysocrius)

## Current state (what actually exists)

- **backend/** — a working FastAPI Phase 1 API: OTP-based auth (JWT), issues CRUD with filters and ownership/admin authorization, and offline sync (push/pull). SQLAlchemy models, Alembic migrations, a constituency seed script, and a pytest suite (14 tests). Runs on SQLite out of the box; point `DATABASE_URL` at Postgres for production.
- **index.html** — a standalone landing/marketing page.
- **frontend (Flutter app), dashboard (web)** — planned, not yet present.

Everything beyond Phase 1 (AI/RAG, blockchain audit, agentic AI, federation/DAO) lives in `PRAJAKEEYA_PLATFORM_BLUEPRINT.md` as the *roadmap*, not a description of what's built.

## Getting started (backend)

```bash
cd backend
pip install -r requirements.txt
cp .env.example .env          # DEBUG=True, SQLite default — no external services needed
alembic upgrade head          # create the schema
python scripts/seed.py        # load sample Karnataka constituencies
pytest -q                     # run the test suite (should be green)
uvicorn app.main:app --reload # then open http://127.0.0.1:8000/docs
```

In `DEBUG` mode, `POST /api/v1/auth/send-otp` returns the OTP in its response so you can complete the auth flow locally without an SMS provider. Disable `DEBUG` in production.

### API surface (Phase 1)

- **Auth:** `POST /api/v1/auth/send-otp`, `POST /api/v1/auth/verify-otp`, `GET /api/v1/auth/me`
- **Constituencies:** `GET /api/v1/constituencies` (optional `?q=` name/code search)
- **Issues:** `GET /api/v1/issues` (filter by constituency/category/status), `GET/POST /api/v1/issues`, `PUT /api/v1/issues/{id}` (owner or admin), `DELETE /api/v1/issues/{id}` (admin)
- **Sync:** `POST /api/v1/sync/push`, `GET /api/v1/sync/pull?since=<ts>`
- **Health:** `GET /api/v1/health`

The Flutter mobile app and web dashboard are planned but not yet implemented.

## Design & roadmap

The full product blueprint — vision, phase-based roadmap (Foundation → AI/RAG → blockchain audit → agentic AI → federation/DAO), tiered authentication model, and deployment plan — is in `PRAJAKEEYA_PLATFORM_BLUEPRINT.md`. Key intended design choices: offline-first Flutter for low-connectivity regions, a Next.js dashboard, and a tiered authentication model.
