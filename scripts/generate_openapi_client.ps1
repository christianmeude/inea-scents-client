Param(
    [string]$OpenApiUrl = 'https://inea-scents.onrender.com/docs?api-docs.json',
    [string]$OutputDir = 'lib/api',
    [string]$Generator = 'dart-dio'
)

Write-Host "Generating OpenAPI client from $OpenApiUrl into $OutputDir using $Generator"

# Ensure output dir exists
if (-not (Test-Path $OutputDir)) { New-Item -ItemType Directory -Path $OutputDir | Out-Null }

# Example: requires openapi-generator-cli installed (Java). Adjust path if needed.
openapi-generator-cli generate -i $OpenApiUrl -g $Generator -o $OutputDir --additional-properties=supportsEnumerations=true

Write-Host "Done. Run 'flutter pub run build_runner build' if using freezed/json_serializable on generated code."
