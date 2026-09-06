#!/bin/bash
# Install Flutter SDK if not present
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable
else
  cd flutter && git pull && cd ..
fi

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# 12-Factor: API_URL passed per Vercel env (Vercel env dashboard).
# Only prod exists in the cloud — Preview and Production both use the prod URL
# (see backend docs/adr/0009-two-environments.md).
# Production/Preview -> https://inea-scents.onrender.com (prod DB)
# Local `flutter run` passes --dart-define=API_URL=http://127.0.0.1:8000 manually.
: "${API_URL:?API_URL dart-define is required. Set Vercel env API_URL=https://inea-scents.onrender.com for Production and Preview.}"

# Enable web and build
flutter config --enable-web
flutter pub get
dart run swagger_parser || true
dart run build_runner build -d || true
flutter build web --release --dart-define=API_URL="$API_URL"
