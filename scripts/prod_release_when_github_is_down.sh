#! /bin/bash

# Script stops if any command fails
set -e
set -o pipefail

set -a
source scripts/build.prod.env
set +a

flutter test

date=`echo "$(date +%s)"`

flutter build ipa \
    --flavor prod \
    --export-options-plist=ios/ProdOptionsPlist.plist \
    --build-number=$date

flutter build apk \
    --flavor prod \
    --build-number=$date
