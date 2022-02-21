#! /bin/bash

# Script stops if any command fails
set -e
set -o pipefail

flutter test

date=`echo "$(date +%s)"`

flutter build ipa \
    --flavor prod \
    --export-options-plist=ios/ProdOptionsPlist.plist \
    --build-number=$date

flutter build apk \
    --flavor prod \
    --build-number=$date
