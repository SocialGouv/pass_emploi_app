#! /bin/bash

# Script stops if any command fails
set -e
set -o pipefail

flutter test

date=`echo "$(date +%s)"`

flutter build ipa \
    --flavor staging \
    --export-options-plist=ios/StagingOptionsPlist.plist \
    --build-number=$date


flutter build apk \
    --flavor staging \
    --build-number=$date

firebase appdistribution:distribute build/app/outputs/flutter-apk/app-staging-release.apk \
    --token "$STAGING_FIREBASE_CI_TOKEN" \
    --app "$STAGING_ANDROID_APP_ID" \
    --release-notes "$RELEASE_NOTE" \
    --groups "$STAGING_FIREBASE_RELEASE_GROUPS"

firebase appdistribution:distribute build/ios/ipa/pass_emploi_app.ipa \
    --token "$STAGING_FIREBASE_CI_TOKEN" \
    --app "$STAGING_IOS_APP_ID" \
    --release-notes "$RELEASE_NOTE" \
    --groups "$STAGING_FIREBASE_RELEASE_GROUPS"