
Write-Host "Building Flutter web app..."
flutter build web --base-href /

Write-Host "Cleaning old build from Laravel public directory..."
$LARAVEL_PUBLIC = "../inea-scents/public"
Remove-Item -Recurse -Force "$LARAVEL_PUBLIC/assets" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$LARAVEL_PUBLIC/canvaskit" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$LARAVEL_PUBLIC/icons" -ErrorAction SilentlyContinue
Remove-Item -Force "$LARAVEL_PUBLIC/flutter.js" -ErrorAction SilentlyContinue
Remove-Item -Force "$LARAVEL_PUBLIC/flutter_bootstrap.js" -ErrorAction SilentlyContinue
Remove-Item -Force "$LARAVEL_PUBLIC/flutter_service_worker.js" -ErrorAction SilentlyContinue
Remove-Item -Force "$LARAVEL_PUBLIC/index.html" -ErrorAction SilentlyContinue
Remove-Item -Force "$LARAVEL_PUBLIC/main.dart.js" -ErrorAction SilentlyContinue
Remove-Item -Force "$LARAVEL_PUBLIC/manifest.json" -ErrorAction SilentlyContinue
Remove-Item -Force "$LARAVEL_PUBLIC/version.json" -ErrorAction SilentlyContinue
Remove-Item -Force "$LARAVEL_PUBLIC/favicon.png" -ErrorAction SilentlyContinue
Remove-Item -Force "$LARAVEL_PUBLIC/.last_build_id" -ErrorAction SilentlyContinue

Write-Host "Copying new build to Laravel public directory..."
Copy-Item -Path "build/web/*" -Destination $LARAVEL_PUBLIC -Recurse -Force

Write-Host "Done! The web app is now fully synced to Laravel."
