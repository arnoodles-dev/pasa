#!/usr/bin/env bash
# This script builds White Label & QA Only

# The script will terminate after the first line that fails
set -e

echo "Build DEV"
scripts/build_android.sh \
 "apk" \
 "release" \
 "development" \
 "lib/main_development.dart" \
 "development.apk"