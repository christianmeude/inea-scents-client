#!/bin/bash
# Install Flutter SDK if not present
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable
else
  cd flutter && git pull && cd ..
fi

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Enable web and build
flutter config --enable-web
flutter pub get
flutter build web --release
