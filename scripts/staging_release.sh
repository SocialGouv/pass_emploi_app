#! /bin/bash

# Script stops if any command fails
set -e
set -o pipefail

set -a
source scripts/build.env
set +a

flutter test

flutter build ipa \
    --flavor staging \
    --dart-define=SERVER_BASE_URL=$STAGING_SERVER_BASE_URL \
    --dart-define=FIREBASE_ENVIRONMENT_PREFIX=staging \
    --export-options-plist=ios/StagingOptionsPlist.plist

flutter build apk \
    --flavor staging \
    --dart-define=SERVER_BASE_URL=$STAGING_SERVER_BASE_URL \
    --dart-define=FIREBASE_ENVIRONMENT_PREFIX=staging

firebase appdistribution:distribute build/app/outputs/flutter-apk/app-staging-release.apk \
    --token "$STAGING_FIREBASE_CI_TOKEN" \
    --app "$STAGING_ANDROID_APP_ID" \
    --release-notes "$RELEASE_NOTE" \
    --groups "$STAGING_FIREBASE_RELEASE_GROUPS"

firebase appdistribution:distribute ios-release/pass_emploi_app.ipa \
    --token "$STAGING_FIREBASE_CI_TOKEN" \
    --app "$STAGING_IOS_APP_ID" \
    --release-notes "$RELEASE_NOTE" \
    --groups "$STAGING_FIREBASE_RELEASE_GROUPS"