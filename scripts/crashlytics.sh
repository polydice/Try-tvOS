#!/bin/sh

if [ "$CONFIGURATION" = "Release" ] && [ "$CI" != true ]; then
  "${PODS_ROOT}/FirebaseCrashlytics/run"
else
  echo "Skip Crashlytics script"
fi
