#!/bin/bash

source common.sh

result=""

if [[ ${COMMIT_URL} == *"visualstudio.com"* ]]; then
    echo "TFS Git repo detected, attaching repo to work item \n"
    # TODO: implement attaching to work item.
else
    echo "External git repo detected, attaching repo to work item history \n"
    result=$(updateWitHistoryWithExternalGit "${ACCOUNT}" "${COLLECTION}" "${WIT_ID}" "${API_VERSION}" "${COMMIT}" "${COMMIT_URL}")
fi

eval "${result}"