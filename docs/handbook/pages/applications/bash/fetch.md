# HomeSetup Applications Handbook

## Table of contents

<!-- toc -->
- [Bash Apps](../../applications.md#bash-apps)
  * [App-Commons](app-commons.md)
  * [Check-IP](check-ip.md)
  * [Fetch](fetch.md)
  * [HHS-App](hhs-app.md)
- [Python Apps](../../applications.md#python-apps)
  * [Free](../py/free.md)
  * [Json-Find](../py/json-find.md)
  * [PPrint-xml](../py/pprint-xml.md)
  * [Print-Uni](../py/print-uni.md)
  * [Send-Msg](../py/send-msg.md)
  * [TCalc](../py/tcalc.md)
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
