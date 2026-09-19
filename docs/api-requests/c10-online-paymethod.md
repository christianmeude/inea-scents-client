# API request — C10 (c10-online-paymethod)

Date: 2026-09-19. Ticket: C10 client — online `payment_method` sends `online` + PayMongo checkout.

## Finding

`POST /api/bookings` with the UI's `online` value fails validation before reaching
PayMongo. The client serializes `online` as the literal string `$unknown` because the
vendored `api-docs.json` (codegen input) still lists the retired enum
`credit_card | cash | bank_transfer`, while the backend accepts `online | cash`.

## Backend state (verified, no change needed)

- `app/Enums/PaymentMethod.php`: `ONLINE='online'`, `CASH='cash'`.
- `app/Http/Controllers/Api/BookingController.php:72` (OpenAPI) and `:104`
  (runtime `Rule::enum`): `online | cash`.
- `storage/api-docs/api-docs.json` (backend export): `payment_method` enum
  `["online", "cash"]`.

## Request

No backend change requested. Client syncs its vendored `api-docs.json` snapshot to
the backend export (`online | cash`) and regenerates `lib/api` via the project's
own codegen (`swagger_parser` + `build_runner`). No hand-edits to generated files.
