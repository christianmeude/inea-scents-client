# ADR 0003 — Payment and Confirmation Authority

## Status
Accepted

## Context
Online methods (`gcash`, `maya`, `credit_card`) are settled via a PayMongo Checkout Link (`POST /api/bookings` returns `checkout_url`). Offline methods (`cash`, `bank_transfer`) require admin approval. The client must never treat "link opened" as "paid".

## Decision
- Online: `Pending → Confirmed` authority is the PayMongo `link.payment.paid` webhook (or admin). Single-use link; pending cron expires after ~15 min to `Cancelled`.
- Offline: `Pending → Confirmed` authority is admin approval.
- Client opens the link with `url_launcher` (web: new tab) fire-and-forget, then polls `GET /api/bookings` every ~3s until `confirmed|paid → confirmed` or `cancelled|expired|canceled → cancelled`. Manual "Check Status"/"Recheck" buttons issue a single immediate fetch (`checkStatusImmediate`) that updates state only when resolved, never forcing a cancellation and never interrupting the shared poll timer. Polling survives transient errors and is cancelled on `dispose`/`rebook`/`reset`/new submit.

## Consequences
- "Resume payment for stale Pending" is intentionally not built (single-use links).
- Polling is the only confirmation signal the UI may use; no local card data is collected or sent.
- Mobile and desktop share the same checkout status screen (`BookingCheckoutStatus`).
