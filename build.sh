#!/bin/bash

# Scarica l'ultima versione stabile di Flutter
echo "Cloning Flutter stable..."
git clone https://github.com/flutter/flutter.git -b stable

# Aggiungi Flutter al PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Risolvi le dipendenze
echo "Running flutter pub get..."
flutter pub get

# Costruisci l'app per il web
echo "Building Flutter web..."
flutter build web --release
