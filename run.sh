#!/usr/bin/bash

# check if google cloud account is present
if [ -z "$WERCKER_GCR_AUTH_ACCOUNT" ]; then
  fail "Please provide a Google Cloud Account"
fi

# check if refresh token is present
if [ -z "$WERCKER_GCR_AUTH_REFRESH_TOKEN" ]; then
  fail "Please provide a Google Cloud refresh token"
fi

# install jq if not installed
if ! hash jq 2>/dev/null; then
  wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
  install -m755 jq-linux64 /usr/local/bin/jq
fi

# install gcloud sdk if not installed
if ! hash gcloud 2>/dev/null; then
  export CLOUDSDK_CORE_DISABLE_PROMPTS=true
  cd /opt && wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz && tar -xvf google-cloud-sdk.tar.gz && google-cloud-sdk/install.sh && rm google-cloud-sdk.tar.gz
  ln -s /opt/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud
fi

# gcr.io authentication
gcloud auth activate-refresh-token "$WERCKER_GCR_AUTH_ACCOUNT" "$WERCKER_GCR_AUTH_REFRESH_TOKEN"
gcloud docker --authorize-only
export GCR_AUTH_TOKEN=$(jq --raw-output '.["https://gcr.io"].auth' ~/.dockercfg | base64 --decode | cut -d ':' -f2)

# cleanup
mv ~/.bashrc.backup ~/.bashrc
rm -rf ~/.config/gcloud
rm ~/.dockercfg
rm /usr/local/bin/gcloud
rm -rf /opt/google-cloud-sdk
