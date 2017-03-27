#!/bin/bash

set -e

exec 3>&1 # make stdout available as file descriptor 3 for the result
exec 1>&2 # redirect all output to stderr for logging

source $(dirname $0)/common.sh

source=$1

if [ -z "$source" ]; then
  echo "usage: $0 <path/to/source>"
  exit 1
fi

# for jq
PATH=/usr/local/bin:$PATH

payload=$(mktemp $TMPDIR/vsts-resource-request.XXXXXX)

cat > $payload <&0

uri=$(jq -r '.source.uri // ""' < $payload)
branch=$(jq -r '.source.branch // ""' < $payload)
repository=$(jq -r '.params.repository // ""' < $payload)
remote_type=$(jq -r '.params.commit_url // "vsts"' < $payload)
remote_commit_uri=$(jq -r '.params.remote_commit_uri // ""' < $payload)
vsts_user=$(jq -r '.params.vsts_user // ""' < $payload)
vsts_pat=$(jq -r '.params.vsts_pat // ""' < $payload)
vsts_account=$(jq -r '.params.vsts_account // ""' < $payload)
vsts_collection=$(jq -r '.params.vsts_collection // ""' < $payload)
vsts_api_version=$(jq -r '.params.vsts_api_version // "1.0"' < $payload)


if [ -z "$uri" ]; then
  echo "invalid payload (missing uri)"
  exit 1
fi

if [ -z "$branch" ]; then
  echo "invalid payload (missing branch)"
  exit 1
fi

if [ -z "$repository" ]; then
  echo "invalid payload (missing repository)"
  exit 1
fi

if [[ "$remote_type" == "other" && -z "$remote_commit_uri" ]]; then
    echo "remote_type other was specified. (missing remote_commit_uri: You must provide a uri for viewing commits)"
    exit 1
fi

commit_uri=""
if [[ "$remote_type" == "vsts" ]]; then
    commit_uri=""
fi


git clone --branch $branch $uri
cd $repository

commit_sha=$(git log -1 | grep 'commit' | awk '{print $2}')
wit_id=$(git log -1 --pretty=%B | grep -o '\#[0-9]\+' | grep -o '[0-9]\+')


if [[ ${uri} == *"visualstudio.com"* ]]; then
    echo "TFS Git repo detected, attaching repo to work item"
    updateWitHistoryWithTfsGit "${ACCOUNT}" "${COLLECTION}" "${WIT_ID}" "${API_VERSION}" "${COMMIT}" "${COMMIT_URL}"
else
    echo "External git repo detected, attaching repo to work item history"
    updateWitHistoryWithExternalGit "${ACCOUNT}" "${COLLECTION}" "${WIT_ID}" "${API_VERSION}" "${COMMIT}" "${COMMIT_URL}"
fi
