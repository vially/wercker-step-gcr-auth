#!/usr/bin/bash

# check if google cloud service account is present
if [ -z "$WERCKER_GCR_AUTH_SERVICE_ACCOUNT" ]; then
  fail "Please provide a Google Cloud Account"
fi

# check if refresh token is present
if [ -z "$WERCKER_GCR_AUTH_REFRESH_TOKEN" ]; then
  fail "Please provide a Google Cloud refresh token"
fi

# gcr.io authentication
"$WERCKER_STEP_ROOT"/gcloud auth activate-refresh-token "$WERCKER_GCR_AUTH_SERVICE_ACCOUNT" "$WERCKER_GCR_AUTH_REFRESH_TOKEN"
"$WERCKER_STEP_ROOT"/gcloud docker --authorize-only
GCR_AUTH_TOKEN=$("$WERCKER_STEP_ROOT"/jq --raw-output '.["https://gcr.io"].auth' ~/.dockercfg | base64 --decode | cut -d ':' -f2)
export GCR_AUTH_TOKEN

# cleanup
rm -rf ~/.config/gcloud
rm ~/.dockercfg
