# API request — C49 (c49-paymongo-pending)

Date: 2026-09-22. Ticket: C49 client — PayMongo success leaves Booking pending.

## Client finding (fixed client-side, no backend change needed for this part)

`BookingFlowNotifier.startPolling` (`lib/providers/index.dart`) forced
`checkoutStatus = cancelled` when the poll window lapsed, even when
`GET /api/bookings` still returned the Booking as `Pending`. That fabricated
a cancellation the server never issued, killed the only observer (poll
timer), and left the cancelled screen with no `checkStatusImmediate`
affordance — so a late PayMongo success could never flip the Booking off
pending in the client. Same bug class as the one-shot path fixed in
`cab4719` (`checkStatusImmediate` never forces cancellation).

Fix: on timeout the client runs one final reconcile (`checkStatusImmediate`)
and flips only on a resolved Status (`Confirmed`/`paid` → confirmed,
`Cancelled`/`expired`/`canceled` → cancelled). A still-`Pending` Booking
keeps `awaitingPayment` with Recheck available. Covered by
`test/c49_paymongo_pending_test.dart` (timeout-pending, timeout-missing,
late-success-via-recheck, all in backend wire case `Pending`/`Confirmed`).

## Backend state (verified read-only, no client edits outside this repo)

- `app/Enums/BookingStatus.php`: `Pending | Confirmed | Cancelled`
  (Title Case on the wire; client matches case-insensitively).
- `app/Actions/ConfirmBookingFromWebhook.php`: only `Pending` Bookings move
  to `Confirmed`; everything else is a logged no-match.
- `app/Models/Booking.php:expireStalePending()`: runs sweep-first on every
  `GET /api/bookings` (also `AvailabilityCalculator`, `CreateBooking`), so
  the client's own poll request expires the Booking ~15 min after creation.

## Request

1. Late-paid race: a customer who completes the PayMongo Checkout after the
   15-minute hold (or whose `link.payment.paid` webhook arrives after the
   sweep) pays real money against a `Cancelled` (or soon-cancelled) Booking,
   and the webhook no-matches because only `Pending` moves. Please confirm
   the intended handling on the backend track: confirm-if-paid-event-matches
   regardless of expiry-cancel, or an explicit paid-but-unmatched admin
   flow (refund/manual confirm). The client cannot distinguish these states
   via `GET /api/bookings` alone.
2. Remarks extraction: `PayMongoWebhookController:73` reads the Booking
   reference from `data.attributes.data.attributes.remarks`. Please verify
   against a real `link.payment.paid` payload that the paid event carries
   the link `remarks` at that path — if any event shape omits it, the
   Booking stays `Pending` forever (the exact symptom behind this ticket)
   with only a silent skip. A log line for paid-events-without-remarks
   would make the next occurrence diagnosable from the client side.

No new client endpoint is consumed by this ticket; if the backend track
adds a reconcile/verify affordance later, the client will adopt it in a
follow-up ticket.
