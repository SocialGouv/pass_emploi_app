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