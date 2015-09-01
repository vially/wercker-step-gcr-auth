#!/usr/bin/bash

# check if refresh token is present
if [ -z "$WERCKER_GCR_AUTH_REFRESH_TOKEN" ]; then
  fail "Please provide a Google Cloud refresh token"
fi

# gcr.io authentication
GCR_AUTH_TOKEN=$("$WERCKER_STEP_ROOT"/gauthtoken "$WERCKER_GCR_AUTH_REFRESH_TOKEN")
export GCR_AUTH_TOKEN
