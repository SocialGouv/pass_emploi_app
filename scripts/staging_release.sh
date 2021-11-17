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

firebase appdistribution:distribute build/ios/ipa/pass_emploi_app.ipa \
    --token "$STAGING_FIREBASE_CI_TOKEN" \
    --app "$STAGING_IOS_APP_ID" \
    --release-notes "$RELEASE_NOTE" \
    --groups "$STAGING_FIREBASE_RELEASE_GROUPS"