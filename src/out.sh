#!/bin/bash

source common.sh

if [[ ${COMMIT_URL} == *"visualstudio.com"* ]]; then
    echo "TFS Git repo detected, attaching repo to work item"
    updateWitHistoryWithTfsGit "${ACCOUNT}" "${COLLECTION}" "${WIT_ID}" "${API_VERSION}" "${COMMIT}" "${COMMIT_URL}"
else
    echo "External git repo detected, attaching repo to work item history"
    updateWitHistoryWithExternalGit "${ACCOUNT}" "${COLLECTION}" "${WIT_ID}" "${API_VERSION}" "${COMMIT}" "${COMMIT_URL}"
fi
