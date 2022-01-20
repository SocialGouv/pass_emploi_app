#! /bin/bash

rm ci/env.ci
cp scripts/build.env ci/env.ci

echo -e "\nSTAGING_GOOGLE_SERVICE_B64=" >> ci/env.ci
cat android/app/src/staging/google-services.json | base64 >> ci/env.ci

echo -e "\nSTAGING_KEYSTORE_B64=" >> ci/env.ci
cat android/keystore/passemploi.jks | base64 >> ci/env.ci

echo -e "\nSTAGING_KEY_PROPERTIES_B64=" >> ci/env.ci
cat android/key.properties | base64 >> ci/env.ci

echo -e "\nSTAGING_RUNTIME_ENV_B64=" >> ci/env.ci
cat env/.env.staging | base64 >> ci/env.ci

echo -e "\nSTAGING_GOOGLE_SERVICE_IOS_B64=" >> ci/env.ci
cat ios/firebase-config/staging/GoogleService-Info.plist | base64 >> ci/env.ci

echo -e "\nSTAGING_OPTIONS_PLIST_B64=" >> ci/env.ci
cat ios/StagingOptionsPlist.plist | base64 >> ci/env.ci

echo -e "\nP12_B64=" >> ci/env.ci
cat ios/cert.p12 | base64 >> ci/env.ci

echo -e "\nP12_PASSWORD=A_DEMANDER_A_LA_TEAM" >> ci/env.ci

echo -e "\nSTAGING_IOS_PROVISIONING_PROFILE_B64=" >> ci/env.ci
cat ci/frfabriquesocialgouvpassemploistaging.mobileprovision | base64 >> ci/env.ci

echo -e "\nAPPLE_STAGING_PROVISIONNING_PROFILE_ID=76GBKHVK25.fr.fabrique.social.gouv.passemploi.staging" >> ci/env.ci

echo -e "\nAPPLE_TEAM_ID=76GBKHVK25" >> ci/env.ci

echo -e "\nAPPLE_CODE_SIGN_IDENTITY=iPhone Distribution: Fabrique numerique des ministeres sociaux" >> ci/env.ci

echo -e "\nPROD_GOOGLE_SERVICE_B64=" >> ci/env.ci
cat android/app/src/prod/google-services.json | base64 >> ci/env.ci

echo -e "\nKEYSTORE_B64=" >> ci/env.ci
cat android/keystore/passemploi.jks | base64 >> ci/env.ci

echo -e "\nKEY_PROPERTIES_B64=" >> ci/env.ci
cat android/key.properties | base64 >> ci/env.ci

echo -e "\nPROD_RUNTIME_ENV_B64=" >> ci/env.ci
cat env/.env.prod | base64 >> ci/env.ci

echo -e "\nPROD_GOOGLE_SERVICE_IOS_B64=" >> ci/env.ci
cat ios/firebase-config/prod/GoogleService-Info.plist | base64 >> ci/env.ci

echo -e "\nPROD_OPTIONS_PLIST_B64=" >> ci/env.ci
cat ios/ProdOptionsPlist.plist | base64 >> ci/env.ci

echo -e "\nPROD_IOS_PROVISIONING_PROFILE_B64=" >> ci/env.ci
cat ci/frfabriquesocialgouvpassemploi.mobileprovision | base64 >> ci/env.ci

echo -e "\nAPPLE_PROD_PROVISIONING_PROFILE_ID=76GBKHVK25.fr.fabrique.social.gouv.passemploi.distribution" >> ci/env.ci