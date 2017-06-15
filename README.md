# VSTS Resource

Links external git commits to VSTS Workitems.


## Source Configuration

* `remote_commit_uri`: *Required.* Uri to display the commit information (e.g. https://github.com/weaverb/vsts-resource/commit).

* `vsts_account`: *Required.* The vsts account name (e.g. https://**accountname**.visualstudio.com).

* `vsts_user`: *Required.* VSTS account user name.

* `vsts_pat`: *Required.* VSTS [Personal Access Token](https://www.visualstudio.com/en-us/docs/setup-admin/team-services/use-personal-access-tokens-to-authenticate).

* `vsts_collection`: *Optional.* The VSTS Collection to use.  Defaults to `DefaultCollection`

* `vsts_api_version`: *Optional.* REST API verison to use. Defaults to `1.0`. 

* `curl_ntlm`: *Optional.* adds the `--ntlm` option to the curl commands.

  Note: Althought this resource currently has not been tested with On-Premise TFS, the ntlm option allows the use of windows credentials for authenticating with TFS 2012 - 2015.3.  TFS 2017+ has the ability to use Personal Access Tokens like VSTS.

* `curl_insecure`: *Optional.* Adds the `-k` option to the curl commands to skip ssl verification.

### Example

Basic resource configuration for linking a GitHub commit to a VSTS work item:

``` yaml
    resource_types:
    - name: vsts-resource
      type: docker-image
      source:
        repository: bsweaver/vsts-resource
        tag: latest
    resources:
      - name: repo
        type: git
        source: 
          uri: git@github.com:weaverb/flight-school.git
          branch: master
          private_key: {{github-private-key}}
        check_every: 10s
      - name: vsts
        type: vsts-resource
        source:
          remote_commit_uri: https://github.com/weaverb/flight-school/commit    
          vsts_account: bweaver
          vsts_user: {{vsts-user}}
          vsts_pat: {{vsts-pat}}

    jobs:
      - name: link-commit-to-vsts
        public: true
        plan:
          - get: repo
          - put: vsts
```

## Behavior

### `check`: 

Not used currently

### `in`: 

Not used currently

### `out`: Push hyperlink to the commit to VSTS

When triggered the resource will scan the latest commit message from the git repo looking for a work item id number prefixed with a `#` (e.g. `#177`).  If found, a hyperlink will be added to the history field of the work item for the target Collection and Project.

*Example:*

![Work item example](https://raw.githubusercontent.com/weaverb/vsts-resource/master/example/wit.png "Example commit link")

#### Parameters

No parameters currently.
