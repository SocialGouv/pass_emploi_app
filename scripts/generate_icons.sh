#!/bin/bash

### USAGE
# sh scripts/generate_icons.sh

# Copier les fichiers dans la racine du projet
cp assets_generation/flutter_launcher_icons-brsa.yaml ./flutter_launcher_icons-brsa.yaml
cp assets_generation/flutter_launcher_icons-cej.yaml ./flutter_launcher_icons-cej.yaml

# Exécuter la commande pour générer les icônes
flutter pub run flutter_launcher_icons

# Supprimer les fichiers déplacés
rm ./flutter_launcher_icons-brsa.yaml
rm ./flutter_launcher_icons-cej.yaml
