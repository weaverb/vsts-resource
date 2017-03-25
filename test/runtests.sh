#!/bin/bash

source helper.sh
source common.test

echo $(updateWitHistoryWithExternalGit_Should_Return_Correct_JSON)
echo $(getVstsGitRepoInfo_Should_Return_Correct_JSON)
echo $(updateWitHistoryWithTfsGit_Should_Return_Correct_Result)

echo -e "Tests complete"