#!/usr/bin/env bash

echo "Check release notes lengths…"

MAX_GOOGLE_RN_LENGTH=500
CEJ_RN_LENGTH=$(cat release-notes/cej/whatsnew-fr-FR | wc -m)
BRSA_RN_LENGTH=$(cat release-notes/brsa/whatsnew-fr-FR | wc -m)

if [ "$CEJ_RN_LENGTH" -gt "$MAX_GOOGLE_RN_LENGTH" ]; then
  echo "Release note for CEJ is too long: $CEJ_RN_LENGTH (max: $MAX_GOOGLE_RN_LENGTH)."
  exit 1
fi

if [ "$BRSA_RN_LENGTH" -gt "$MAX_GOOGLE_RN_LENGTH" ]; then
  echo "Release note for CEJ is too long: $BRSA_RN_LENGTH (max: $MAX_GOOGLE_RN_LENGTH)."
  exit 1
fi

echo "Release notes lengths OK"
git add release-notes
git commit -m "build: Update release notes"
echo "Release notes commited"

