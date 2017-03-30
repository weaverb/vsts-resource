#!/bin/bash

PIPELINE_NAME=${1:-vsts-example}
ALIAS=${2:-nonprod}
CREDENTIALS=${3:-credentials.yml}
PIPELINE_CONFIG=${4:-pipeline.yml}

echo y | fly -t "${ALIAS}" sp -p "${PIPELINE_NAME}" -c "${PIPELINE_CONFIG}" -l "${CREDENTIALS}"