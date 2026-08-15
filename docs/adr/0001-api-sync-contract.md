# Automated API Synchronization Contract

The Laravel OpenAPI specification (`api-docs.json`) is the single source of truth for the API contract. To prevent drift, we decided to automate the API client generation using a dual-repository CI/CD workflow where the Backend repo pushes schema updates via PR, and the Mobile repo automatically regenerates and tests the Dart client. This strictly enforces the contract and prevents structural changes from silently breaking the compiled app.

## Status
Accepted

## Consequences
- Developers must not manually edit the generated files inside `lib/api/`.
- Backend engineers must treat breaking structural changes as a block to the mobile app compiling.
