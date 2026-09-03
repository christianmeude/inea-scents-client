# ADR 0004 — Booking Entry Route

## Status
Accepted

## Context
`PackageDetailScreen` "Book Now" previously pushed `/calendar`, a standalone availability browser that showed a selected-date badge with no CTA, leaving the real wizard at `/booking/:id` orphaned. The mobile `TableCalendar` inside the booking wizard was also a divergent, unpolished duplicate with hidden header and no availability wiring.

## Decision
- `Book Now` navigates directly to `/booking/:id` (`GoRouter` path `/booking/:id`). This is the canonical booking entry.
- `/calendar` remains a standalone read-only Availability browser. When a date is selected it shows a non-blocking "Continue with this date → Booking" CTA that can push `/booking/:id?date=YYYY-MM-DD` (initial date seed); it does not auto-navigate.
- The booking wizard uses a single step state machine (`BookingFlowNotifier.currentStep`: 2 Schedule → 3 Details → 4 Payment → 5 Checkout) on all breakpoints. Desktop renders steps 3+4 alongside the sticky order summary but still enforces validation order.
- One shared calendar module (`IneaCalendar`) replaces three divergent implementations (`booking_screen` inline, `ReservationCalendarPanel`, `CalendarScreen` internals).

## Consequences
- All breakpoints share identical functionality and visual treatment; `ResponsiveAppShell` breakpoint constants are the single source of truth.
- Bottom navigation shows 5 tabs on both mobile and desktop (CALENDAR included) to avoid confusion.
