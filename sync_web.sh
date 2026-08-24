#!/bin/bash
# Syncs the Flutter web build to the Laravel public directory.

set -e

echo "Building Flutter web app..."
flutter build web --base-href /

echo "Cleaning old build from Laravel public directory..."
LARAVEL_PUBLIC="../inea-scents/public"
rm -rf $LARAVEL_PUBLIC/assets
rm -rf $LARAVEL_PUBLIC/canvaskit
rm -rf $LARAVEL_PUBLIC/icons
rm -f $LARAVEL_PUBLIC/flutter.js
rm -f $LARAVEL_PUBLIC/flutter_bootstrap.js
rm -f $LARAVEL_PUBLIC/flutter_service_worker.js
rm -f $LARAVEL_PUBLIC/index.html
rm -f $LARAVEL_PUBLIC/main.dart.js
rm -f $LARAVEL_PUBLIC/manifest.json
rm -f $LARAVEL_PUBLIC/version.json
rm -f $LARAVEL_PUBLIC/favicon.png
rm -f $LARAVEL_PUBLIC/.last_build_id

echo "Copying new build to Laravel public directory..."
cp -R build/web/* $LARAVEL_PUBLIC/

echo "Done! The web app is now fully synced to Laravel."
