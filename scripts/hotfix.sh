#!/usr/bin/env bash

upgrade_version() {
  dart pub global activate release_tools
  export PATH="$PATH":"$HOME/.pub-cache/bin"
  release_tools update_version "$new_version"
  git add pubspec.yaml
  git commit -m "build: bump app version"
}

tag() {
  git tag -a $new_version -m "$new_version"
  git push --tags
}

upgrade_version_hotfix() {
  upgrade_version
  tag
}

upgrade_version_main() {
  git checkout main
  git pull --rebase
  upgrade_version
  git push
}

new_version=$1

echo "Hotfix version"

if [ -z "$1" ]; then
  echo "error: a version number must be passed in parameter"
  exit 1
fi

upgrade_version_hotfix
upgrade_version_main

echo "🔴 WARN: Si besoin, veuillez appliquer le correctif également sur la branche main."