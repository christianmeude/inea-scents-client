# ADR 0008: Booking Labels and Reservation Renaming

## Date
2026-09-13

## Context
The term "Reservation" was heavily used in the UI, often paired with "Custom Experience" (e.g., "Reservation — Custom Experience"). This terminology was verbose and didn't align well with the overall product goal of simply booking the service.

## Decision
- **Purge "Reservation"**: The term "Reservation" will be purged from the UI and replaced with `Booking`.
- **Title Distillation**: The verbose title `Reservation — Custom Experience` will be removed. On the reservation step, it will become a distilled one-liner (e.g., `{pax} PAX · {date} · {time}`). On the payment step, it will simply be `Payment & Checkout`.
- **Class Names**: For code continuity and to avoid massive refactoring ahead of the P2 merge, we will keep `Reservation*` class names (like `ReservationDetailsPanel`) and provide `typedef` aliases where beneficial.

## Status
Accepted

## Consequences
- A cleaner, more direct user experience.
- UI terminology strictly aligns with the "Booking" domain term.
- Minimal disruption to existing class structures while achieving the UI text goals.
