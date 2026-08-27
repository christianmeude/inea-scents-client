## Destination
Customers can successfully complete a booking by paying through a secure, frictionless payment gateway integrated into both the mobile and web reservation flows.

## Notes
- **Domain:** Full-stack integration (Flutter frontend + Backend).
- **Goal:** Solidify the payment workflow, provider selection, and state management before writing code.

## Decisions so far
- [#30](https://github.com/christianmeude/inea-scents-client/issues/30) — Use PayMongo as the provider, supporting GCash, Maya, and Credit/Debit Cards.
- [#32](https://github.com/christianmeude/inea-scents-client/issues/32) — Create a 'Pending' Booking locked for 15 mins. Use webhooks for 'Confirmed' and background job for 'Expired'.

## Not yet specified

## Out of scope
-

## Child Tickets
- [ ] #34
- [ ] #35
- [ ] #36

