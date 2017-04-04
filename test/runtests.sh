#!/bin/bash

source helper.sh
source common.test

echo $(updateWitHistoryWithExternalGit_Should_Return_Correct_JSON)
echo $(updateWitHistoryWithExternalGit_Should_Return_Correct_JSON_Curl_Insecure)
echo $(updateWitHistoryWithExternalGit_Should_Return_Correct_JSON_Curl_Ntlm)
echo $(updateWitHistoryWithExternalGit_Should_Return_Correct_JSON_Curl_Ntlm_Insecure)

echo -e "Tests complete"