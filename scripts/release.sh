#!/usr/bin/env bash

upgrade_version() {
  git checkout develop
  git pull --rebase
  dart pub global activate release_tools
  export PATH="$PATH":"$HOME/.pub-cache/bin"
  release_tools update_version "$new_version"
  git add pubspec.yaml
  git commit -m "build: bump app version"
  git push
}

update_master_and_tag() {
  git checkout master
  git pull --rebase
  git merge --no-ff --no-edit develop
  git push
  git tag -a $new_version -m "$new_version"
  git push --tags
}

new_version=$1

echo "Release version"

if [ -z "$1" ]; then
  echo "error: a version number must be passed in parameter"
  exit 1
fi

upgrade_version
update_master_and_tag