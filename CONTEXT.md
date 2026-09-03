# Inea Scents Mobile

The mobile application for Inea Scents, allowing users to browse packages, pick scents, and book events.

## Language

**Package**:
A bundled offering for an event, usually including services, duration, and a set of allowed Scents.
_Avoid_: Bundle, service

**Scent**:
A physical perfume choice that a customer can select to include in a Package. Inventory is not currently tracked per scent.
_Avoid_: Perfume, fragrance

**Booking**:
A day-granular request for a Package on a specific event date. Created `Pending`, advances to `Confirmed` on payment or admin approval, otherwise `Cancelled`. Exactly one Booking per calendar day (physical bar). Holds Pax, informational Time Slot, and Customer contact.
_Avoid_: Reservation, appointment, order

**Status** (of a Booking):
`Pending` (awaiting payment or admin confirmation) → `Confirmed` (paid via webhook or admin-approved) → `Cancelled` (expired, rejected, or customer-cancelled).
_Avoid_: state (ambiguous)

**Pax**:
The headcount for a Booking, selected from Package `paxOptions`. Determines capacity/price.
_Avoid_: guests, capacity, attendees

**Time Slot**:
An informational window (e.g. `2:00 PM - 5:00 PM`) indicating when the bar should be ready. Does NOT affect Availability.
_Avoid_: slot without qualifier

**Availability**:
Day-level status `Available` / `Booked` derived from confirmed Bookings and admin-blocked dates via `GET /api/availability`. Consumed by the booking calendar to disable Booked days.
_Avoid_: openness, free

**User**:
An authenticated account that can browse, wishlist, and book.
_Avoid_: account, member

**Admin**:
The business principal. Portal-only: authenticates at the Admin Dashboard (`/admin/login`) and never via the app. No admin login routing, magic URLs, or admin surfaces exist in this app.
_Avoid_: backend, super admin

**Customer**:
The contact (name, email, phone) a specific Booking is made under. Prefilled from User profile but editable per Booking.
_Avoid_: client, guest

**Payment Method**:
The declared way to settle a Booking: online `credit_card` (PayMongo link page) or offline `cash | bank_transfer` (admin confirms). `isOnline` indicates PayMongo flow. Backend enum: `credit_card | cash | bank_transfer` (legacy `gcash | maya` values no longer emitted).
_Avoid_: payment type, mode

**Checkout**:
The post-submit phase for a Booking: online opens the PayMongo link and polls `GET /api/bookings` until `Confirmed`/`Cancelled`; offline shows awaiting-admin state.
_Avoid_: payment flow, pay

**Environment**:
Build-time backend selection via `API_URL` dart-define: `local` → `http://127.0.0.1:8000` (or `10.0.2.2` on Android), `staging` → `inea-scents-staging.onrender.com`, `production` → `inea-scents.onrender.com`. No runtime enum toggle. 12-Factor III.
_Avoid_: editing `environment.dart` to switch backends
