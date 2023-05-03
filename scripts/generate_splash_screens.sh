#!/bin/bash

### USAGE
# sh scripts/generate_splash_screens.sh

# Exécuter la commande pour générer les splash screens
flutter pub run flutter_native_splash:create --flavor brsa --path=assets_generation/flutter_native_splash-brsa.yaml
flutter pub run flutter_native_splash:create --flavor cej --path=assets_generation/flutter_native_splash-cej.yaml
