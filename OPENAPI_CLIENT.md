# Generating the API client

This project consumes the OpenAPI spec for the Inea Scents backend. Do NOT hand-write models or API clients — generate them from the OpenAPI JSON.

Recommended approaches:

- Install `openapi-generator-cli` (requires Java):

  - npm: `npm install @openapitools/openapi-generator-cli -g`
  - homebrew: `brew install openapi-generator`

- Generate the client (PowerShell):

```powershell
.\n+scripts\generate_openapi_client.ps1 -OpenApiUrl 'https://inea-scents.onrender.com/docs?api-docs.json' -OutputDir 'lib/api'
```

- Or on macOS / WSL / Linux:

```bash
./scripts/generate_openapi_client.sh https://inea-scents.onrender.com/docs?api-docs.json lib/api
```

After generation:

- Inspect `lib/api` for generated models and API classes.
- If the generator produces code that requires `freezed`/`json_serializable`, run:

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

- Wire the generated client into the Riverpod provider in `lib/src/providers/core_providers.dart`.

Notes:

- The provided `DioClient` uses `TokenStorage` to automatically attach the Bearer token.
- Keep `lib/api` generated, do not modify generated files manually; instead re-run the generator.
