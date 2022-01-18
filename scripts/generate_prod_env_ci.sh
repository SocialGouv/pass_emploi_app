#! /bin/bash

rm ci/prod.env.ci
cp scripts/build.env ci/prod.env.ci

echo -e "\nPROD_GOOGLE_SERVICE_B64=" >> ci/prod.env.ci
cat android/app/src/prod/google-services.json | base64 >> ci/prod.env.ci

echo -e "\nKEYSTORE_B64=" >> ci/prod.env.ci
cat android/keystore/passemploi.jks | base64 >> ci/prod.env.ci

echo -e "\nKEY_PROPERTIES_B64=" >> ci/prod.env.ci
cat android/key.properties | base64 >> ci/prod.env.ci

echo -e "\nPROD_RUNTIME_ENV_B64=" >> ci/prod.env.ci
cat env/.env.prod | base64 >> ci/prod.env.ci

echo -e "\nPROD_GOOGLE_SERVICE_IOS_B64=" >> ci/prod.env.ci
cat ios/firebase-config/prod/GoogleService-Info.plist | base64 >> ci/prod.env.ci

echo -e "\nPROD_OPTIONS_PLIST_B64=" >> ci/prod.env.ci
cat ios/ProdOptionsPlist.plist | base64 >> ci/prod.env.ci