#!/usr/bin/env bash
# This script builds Android app

if [[ ! $# == 5 ]]; then
  echo "Required parameters:"
  echo " 1. [apk | appbundle]"
  echo " 2. [release | debug]"
  echo " 3. flavor"
  echo " 4. target"
  echo " 5. artifact name"
  exit 1
fi

# The script will terminate after the first line that fails
set -e

echo "Build apk/appbundle"
if [[ "$1" == "appbundle" && "$3" == "prod"  ]]; then
  flutter build $1 \
  --$2 \
  --flavor $3 \
  --target $4 \
  --obfuscate \
  --split-debug-info=.
else
  flutter build $1 \
  --$2 \
  --flavor $3 \
  --target $4 \
  --obfuscate \
  --split-debug-info=. \
  --build-number $(($BUILD_NUMBER))
fi

echo "Move artifact to a dedicated folder"
mkdir -p "outputs"

if [[ "$1" == "appbundle" ]]; then
  cp "build/app/outputs/bundle/$3Release/app-$3-$2.aab" "outputs/$5"
else
  cp "build/app/outputs/apk/$3/$2/app-$3-$2.apk" "outputs/$5"
fi

# Remove outputs so the next build won't accidentally upload current app if build fails
rm -rf build/app/outputs/