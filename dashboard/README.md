# JanaBala Dashboard

Citizen + admin web dashboard for the JanaBala (Prajakeeya) civic-issue platform.
Next.js (App Router) + TypeScript. Talks only to the backend API over the frozen
`/api/v1` contract; it never imports backend source.

## Setup

```bash
cd dashboard
npm install
cp .env.local.example .env.local   # defaults to http://127.0.0.1:8000/api/v1
npm run dev                         # http://localhost:3000
```

The backend must be running locally (see repo root README). CORS already allows
`http://localhost:3000`. In DEBUG mode, `send-otp` returns `debug_otp` in its
JSON; the login screen surfaces and pre-fills it in dev only.

## Scripts

- `npm run dev` — dev server on port 3000
- `npm run build` — production build
- `npm run typecheck` — `tsc --noEmit`

## Structure

- `src/lib/types.ts` — contract types + enums (single source of truth)
- `src/lib/api.ts` — the only module that builds requests/URLs and attaches the JWT
- `src/lib/auth.tsx` — auth context (token in localStorage, `/auth/me`, admin flag)
- `src/app/page.tsx` — issue list with category/status/constituency filters + pagination
- `src/app/issues/[id]/page.tsx` — issue detail, photos, map pin, admin/owner actions
- `src/app/login/page.tsx` — OTP login flow

## Constituency filter

The constituency filter is populated from `GET /api/v1/constituencies` (public),
which returns `[{ id, name, code, district, state, created_at }]`. Run the backend's
`scripts/seed.py` once to load sample constituencies, or the filter will only show
"All".
