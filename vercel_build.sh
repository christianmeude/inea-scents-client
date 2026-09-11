#!/bin/bash
set -e
# Pinned Flutter SDK: floating on `stable` once broke Vercel codegen
# (Dart 3.13 vs analyzer 3.12 emitted bad outputs). This tag built green.
# Bump deliberately: verify `flutter analyze` + a Vercel deploy, then update.
FLUTTER_VERSION="3.47.3"
# Install Flutter SDK if not present
if [ ! -d "flutter" ]; then
  git clone --depth 1 --branch "$FLUTTER_VERSION" https://github.com/flutter/flutter.git
else
  cd flutter && git fetch --depth 1 origin tag "$FLUTTER_VERSION" && git checkout -q "$FLUTTER_VERSION" && cd ..
fi

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# 12-Factor: API_URL passed per Vercel env (Vercel env dashboard).
# Only prod exists in the cloud — Preview and Production both use the prod URL
# (see backend docs/adr/0009-two-environments.md).
# Production/Preview -> https://inea-scents.onrender.com (prod DB)
# Local `flutter run` passes --dart-define=API_URL=http://127.0.0.1:8000 manually.
: "${API_URL:?API_URL dart-define is required. Set Vercel env API_URL=https://inea-scents.onrender.com for Production and Preview.}"

# Enable web, install deps, and build with committed outputs.
# Codegen (swagger_parser, build_runner) runs locally before pushing —
# never on Vercel: fresh SDK resolves drift codegen deps and emit broken
# outputs (seen: Dart 3.13 vs analyzer 3.12). Fail fast, no "|| true".
flutter config --enable-web
flutter pub get
flutter build web --release --dart-define=API_URL="$API_URL"
