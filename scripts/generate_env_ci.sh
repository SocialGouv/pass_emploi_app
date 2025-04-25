#! /bin/bash

rm ci/env.ci
cp scripts/build.env ci/env.ci

echo -e "\nSTAGING_GOOGLE_SERVICE_B64=" >> ci/env.ci
cat android/app/google-services.json | base64 >> ci/env.ci

echo -e "\nSTAGING_KEYSTORE_B64=" >> ci/env.ci
cat android/keystore/passemploi.jks | base64 >> ci/env.ci

echo -e "\nSTAGING_KEY_PROPERTIES_B64=" >> ci/env.ci
cat android/key.properties | base64 >> ci/env.ci

echo -e "\nSTAGING_RUNTIME_ENV_B64=" >> ci/env.ci
cat env/.env.staging | base64 >> ci/env.ci

echo -e "\nCEJ_STAGING_GOOGLE_SERVICE_IOS_B64=" >> ci/env.ci
cat ios/firebase-config/cejStaging/GoogleService-Info.plist | base64 >> ci/env.ci

echo -e "\nBRSA_STAGING_GOOGLE_SERVICE_IOS_B64=" >> ci/env.ci
cat ios/firebase-config/brsaStaging/GoogleService-Info.plist | base64 >> ci/env.ci

echo -e "\nPROD_GOOGLE_SERVICE_B64=" >> ci/env.ci
cat android/app/src/prod/google-services.json | base64 >> ci/env.ci

echo -e "\nKEYSTORE_B64=" >> ci/env.ci
cat android/keystore/passemploi.jks | base64 >> ci/env.ci

echo -e "\nKEY_PROPERTIES_B64=" >> ci/env.ci
cat android/key.properties | base64 >> ci/env.ci

echo -e "\nPROD_RUNTIME_ENV_B64=" >> ci/env.ci
cat env/.env.prod | base64 >> ci/env.ci

echo -e "\nCEJ_PROD_GOOGLE_SERVICE_IOS_B64=" >> ci/env.ci
cat ios/firebase-config/cejProd/GoogleService-Info.plist | base64 >> ci/env.ci

echo -e "\nBRSA_PROD_GOOGLE_SERVICE_IOS_B64=" >> ci/env.ci
cat ios/firebase-config/brsaProd/GoogleService-Info.plist | base64 >> ci/env.ci
