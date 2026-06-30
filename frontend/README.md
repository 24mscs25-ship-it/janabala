# JanaBala Mobile App (Flutter)

Offline-first civic issue reporting for Karnataka. Flutter + Dart, talks only to
the JanaBala API over the frozen `/api/v1` contract. All API access is funnelled
through one typed client and one sync service so the contract lives in one place.

## Run

```bash
cd frontend/janabala_app
flutter pub get
flutter gen-l10n            # generates lib/l10n/app_localizations.dart
flutter run                 # pick a device (Android emulator / desktop)
```

Point the app at a backend with a compile-time define (defaults to
`http://127.0.0.1:8000/api/v1`):

```bash
flutter run --dart-define=API_BASE=http://10.0.2.2:8000/api/v1   # Android emulator -> host
```

In DEBUG, `send-otp` returns `debug_otp`; the login screen surfaces and
pre-fills it only when `kDebugMode` is true.

## Architecture

- `lib/services/api_client.dart` — the single typed API client. Every endpoint,
  URL, and JSON shape lives here; widgets never touch HTTP.
- `lib/services/local_db.dart` — SQLite (sqflite) mirror. One `issues` table holds
  both server-synced rows (`sync_state = synced`) and the outbound queue
  (`sync_state = pendingCreate`). Plus `constituencies` and a `meta` table for the
  sync cursor.
- `lib/services/sync_service.dart` — offline backbone. On connectivity regain it
  pushes each queued item EXACTLY ONCE (the server is not idempotent on
  `client_id`), marks it synced in a transaction, then pulls since the last
  `server_time` and upserts. Exposes status for the UI indicator.
- `lib/services/issue_repository.dart` — local-first reads with best-effort online
  refresh; new issues write to the queue immediately and trigger a sync.
- `lib/services/auth_service.dart` — OTP login, JWT in `flutter_secure_storage`,
  feeds the token to `ApiClient`.
- `lib/screens/` — login (OTP + cooldown/lockout handling), issue list + filters,
  issue detail, report form (category/urgency/constituency, optional GPS + photo),
  sync indicator, language switcher.
- `lib/l10n/` — i18n via ARB. English (`app_en.arb`) + Kannada (`app_kn.arb`),
  switchable at runtime from the app bar.

## Contract behaviors handled

- **sync/push not idempotent:** each queued issue is pushed individually and
  marked synced on success, so a mid-batch failure never re-pushes created items.
  Verified: a second sync creates no duplicate server rows.
- **sync/pull is a global feed by `updated_at`:** we persist `server_time` from
  each pull in `meta` and pass it as the next `since`.
- **send-otp 60s cooldown / verify-otp lockout:** login starts a 60s resend timer,
  honors `Retry-After` on 429, and shows a friendly "too many attempts" message.

## Verified

- `flutter analyze` — clean (0 issues).
- `flutter test` — unit test (enum wire round-trips) passes.
- `flutter test test/sync_integration_test.dart` — against a LIVE backend on
  `127.0.0.1:8000`: dev-OTP login, create an issue while "offline" (queued
  locally), flip online and sync, then assert the queue drains, exactly one local
  copy gains a server id, exactly one server row exists, and a second sync does
  NOT duplicate. The test auto-skips if the backend is unreachable.

## Not verified (environment limits)

- **Windows desktop build:** `flutter build windows` fails because
  `flutter_secure_storage_windows` needs the Visual Studio ATL header `atlstr.h`,
  which isn't installed in this environment. Dart compiles fine (tests run); this
  is a native toolchain gap, not an app issue. Build on a machine with the VS ATL
  component, or target Android.
- **Real-device GPS & camera:** `geolocator` / `image_picker` flows are wired but
  not exercised on hardware here (no emulator/device with sensors). Needs a manual
  pass on a phone.
- **Photo upload:** the report form captures a photo path locally, but the
  contract only accepts `photo_urls` (no upload endpoint). Photos are not sent
  yet; see "Backend changes requested".

## Backend changes requested

- **Photo upload endpoint.** The app can capture a photo but the contract only
  takes `photo_urls: str[]`. Add something like `POST /api/v1/uploads` returning a
  stored URL (or presigned-URL flow) so the client can attach real photos. Until
  then the app submits issues without photos.
- **(Optional) server-side `client_id` dedup on `sync/push`.** The app already
  guarantees exactly-once by pushing each item once and marking it synced, but if
  a response is lost after the server commits, a retry would duplicate. Honoring
  `client_id` as an idempotency key would make push safely retryable.
