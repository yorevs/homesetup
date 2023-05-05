# <img src="https://iili.io/HvtxC1S.png"  width="34" height="34"> HomeSetup Applications Handbook

## Table of contents

<!-- toc -->
- [Bash Applications](../../applications.md)
  * [App-Commons](app-commons.md#application-commons)
  * [Check-IP](check-ip.md#check-ip-application)
  * [Fetch](fetch.md#fetch-application)
  * [HHS-App](hhs-app.md#homesetup-application)
    + [Functions](hhs-app.md#functions)
    + [Plugins](hhs-app.md#plug-ins)
<!-- tocstop -->

## Fetch application

```bash
Usage:  <method> [options] <url>

        method                      : The http method to be used [ GET, POST, PUT, PATCH, DELETE ].
        url                         : The url to make the request.

    Options:
        --headers <json_headers>    : The http request headers.
        --body    <json_body>       : The http request body (payload).
        --format                    : Format the json responseonse.
        --silent                    : Omits all informational messages.
```

##### **Purpose**:

Fetch URL resource using the most commons ways.

##### **Returns**:

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The Http method to be used.
  - $2 _Required_ : The URL to fetch.

##### **Examples:**

```bash
  $ fetch.bash GET www.google.com
  $ fetch.bash POST --headers "context-type=application/json,accept=*/*"  --body='{"id": 123}' localhost:8080/rest/api
```
