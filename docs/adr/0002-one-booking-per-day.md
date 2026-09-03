# ADR 0002 — One Booking per Calendar Day

## Status
Accepted

## Context
The perfume bar physically travels to one venue per day. Even though time slots (`10:00-13:00`, `14:00-17:00`, `18:00-21:00`) are shown for scheduling, they are informational and do not create extra capacity. Availability must therefore be day-granular. The backend `CreateBooking` and `AvailabilityCalculator` enforce this; the mobile calendar must mirror it.

## Decision
- A Booking is scoped to an `event_date` (day, not datetime).
- At most one non-cancelled Booking per calendar day across all packages/time slots.
- `GET /api/availability?month&year` is the source of truth (`[{date, status: available|booked}]`); the booking calendar disables `booked` days via `enabledDayPredicate`.
- `TimeSlot` remains decorative and never participates in availability.

## Consequences
- Client must refetch availability on month navigation (`setMonth`) and handle mid-flow 422 (`event_date` already booked/blocked) on submit.
- Customer cancellation (24h-before rule) is follow-up work and does not alter day-granularity.
