#!/usr/bin/env bash
OPENAPI_URL=${1:-https://ineascents.onrender.com/docs?api-docs.json}
OUT_DIR=${2:-lib/api}
GENERATOR=${3:-dart-dio}

echo "Generating OpenAPI client from $OPENAPI_URL into $OUT_DIR using $GENERATOR"
mkdir -p "$OUT_DIR"
openapi-generator-cli generate -i "$OPENAPI_URL" -g "$GENERATOR" -o "$OUT_DIR" --additional-properties=supportsEnumerations=true
echo "Done. Run 'flutter pub run build_runner build' if using freezed/json_serializable on generated code."
