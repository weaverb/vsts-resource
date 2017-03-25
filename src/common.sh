#!/bin/bash

function updateWitHistoryWithExternalGit() {
    local account="${1}"
    local collection="${2}"
    local id="${3}"
    local apiVersion="${4}"
    local commit="${5}"
    local commitUrl="${6}"
    local vstsUser="${7:-$VSTS_USER}"
    local vstsPat="${8:-$VSTS_PAT}"

    # Update Work Item API Documentation: https://www.visualstudio.com/en-us/docs/integrate/api/wit/work-items#update-work-items
    local header="Content-Type: application/json-patch+json"
    local payload='[{"op": "add","path": "/fields/System.History","value": "External Git commit: <a href=\"'${commitUrl}'/'${commit}'\">'${commit}'</a>" }]'
    local url="https://${account}.VisualStudio.com/${collection}/_apis/wit/workitems/${id}?api-version=${apiVersion}"

    echo $header

    curl -u ${vstsUser}:${vstsPat} --request PATCH --header "$header" --data "$payload" ${url}
}

function updateWitHistoryWithTfsGit() {
    local account="${1}"
    local collection="${2}"
    local id="${3}"
    local apiVersion="${4}"
    local commit="${5}"
    local cloneUrl="${6}"
    local vstsUser="${7:-$VSTS_USER}"
    local vstsPat="${8:-$VSTS_PAT}"

    local repoInfo=$(getVstsGitRepoInfo "${cloneUrl}" "${vstsUser}" "${vstsPat}")
    local projectId=${repoInfo} | jq .repository.project.id
    local repoId=${repoInfo} | jq .repository.id

    # Update Work Item API Documentation: https://www.visualstudio.com/en-us/docs/integrate/api/wit/work-items#update-work-items
    local header="Content-Type: application/json-patch+json"
    local payload='[{"op": "add","path": "/relations/-","value": { "rel": "ArtifactLink", "url": "vstfs://Git/Commit/'${projectId}'%2F'${repoId}'%2F'${commit}'" }}]'
    local url="https://${account}.VisualStudio.com/${collection}/_apis/wit/workitems/${id}?api-version=${apiVersion}"

    curl -u ${vstsUser}:${vstsPat} --request PATCH --header \"${header}\" --data '${payload}' ${url}
}

function getVstsGitRepoInfo() {
    local cloneUrl="${1}"
    local vstsUser="${2:-$VSTS_USER}"
    local vstsPat="${3:-$VSTS_PAT}"

    curl -u ${vstsUser}:${vstsPat} "${cloneUrl}/vsts/info"
}