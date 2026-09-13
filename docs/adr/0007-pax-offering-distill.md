# ADR 0007: Pax and Offering Distillation

## Date
2026-09-13

## Context
There has been a need to standardize how we refer to the headcount and the service offering within the application, particularly in the client UI and the domain model. Terms like "Guests", "Tier", and "Package" were used interchangeably, causing confusion. Furthermore, the base service offering is identical across different sizes, with the only variation being the number of PAX.

## Decision
- **Pax Canonicalization**: We will use `PAX` (uppercase) consistently in the UI instead of "Guests" or "Capacity".
- **Offering vs Package Variant**: We distinguish between the `Offering` (the single base service, e.g., 10ml essential with fixed inclusions and freebies) and the `Package Variant` or `Pax Choice` (the customer-visible configuration based on pax size). 
- **Duration**: Duration (e.g., "3-4 hrs") is removed from the fixed inclusions list. It is treated as a hint for the owner, not a strictly selectable or verifiable booking field.
- **Code Alias**: We will keep `Package` as an API DTO alias for backend syncing, but UI copy should avoid saying "Package" or "Tier".

## Status
Accepted

## Consequences
- Unified and clearer terminology in the UI and documentation.
- The fixed offering list (inclusions and freebies) can be centralized into a single client constant, ignoring/merging API lists that attempt to redefine it.
