<img src="https://iili.io/HvtxC1S.png" width="64" height="64" align="right" />

# HomeSetup Developer Handbook
>
> Applications handbook

## Table of contents

<!-- toc -->

- [Bash Applications](../../applications.md)
  - [Check-IP](check-ip.md#check-ip)
  - [Fetch](fetch.md#fetch)
  - [HHS-App](hhs-app.md#homesetup-application)
    - [Functions](hhs-app.md#functions)
      - [Built-Ins](hhs-app/functions/built-ins.md)
      - [Misc](hhs-app/functions/misc.md)
      - [Tests](hhs-app/functions/tests.md)
      - [Web](hhs-app/functions/web.md)
    - [Plugins](hhs-app.md#plug-ins)
      - [Firebase](hhs-app/plugins/firebase.md)
      - [HSPM](hhs-app/plugins/hspm.md)
      - [Settings](hhs-app/plugins/settings.md)
      - [Setup](hhs-app/plugins/setup.md)
      - [Starship](hhs-app/plugins/starship.md)
      - [Updater](hhs-app/plugins/updater.md)

<!-- tocstop -->

## Fetch

```bash
usage:  <method> [options] <url>

        method                      : The http method to be used \[ GET, POST, PUT, PATCH, DELETE \].
        url                         : The url to make the request.

    Options:
        --headers <json_headers>    : The http request headers.
        --body    <json_body>       : The http request body (payload).
        --format                    : Format the json responseonse.
        --silent                    : Omits all informational messages.
```

### **Purpose**

Fetch URL resource using the most commons ways.

### **Returns**

**0** if the command executed successfully; **non-zero** otherwise.

### **Parameters**

- $1 _Required_ : The Http method to be used.
- $2 _Required_ : The URL to fetch.

### **Examples**

`fetch.bash GET example.com`

**Output**

```html
<!doctype html>
<html>
<head>
    <title>Example Domain</title>
    <meta charset="utf-8" />
    <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style type="text/css">
    body {
        background-color: #f0f0f2;
        margin: 0;
        padding: 0;
        font-family: -apple-system, system-ui, BlinkMacSystemFont, "Segoe UI", "Open Sans", "Helvetica Neue", Helvetica, Arial, sans-serif;

    }
    div {
        width: 600px;
        margin: 5em auto;
        padding: 2em;
        background-color: #fdfdff;
        border-radius: 0.5em;
        box-shadow: 2px 3px 7px 2px rgba(0,0,0,0.02);
    }
    a:link, a:visited {
        color: #38488f;
        text-decoration: none;
    }
    @media (max-width: 700px) {
        div {
            margin: 0 auto;
            width: auto;
        }
    }
    </style>
</head>
<body>
<div>
    <h1>Example Domain</h1>
    <p>This domain is for use in illustrative examples in documents. You may use this
    domain in literature without prior coordination or asking for permission.</p>
    <p><a href="https://www.iana.org/domains/example">More information...</a></p>
</div>
</body>
</html>
```

`fetch.bash POST --headers "context-type=application/json,accept=*/*"  --body='{"id": 123}' localhost:8080/rest/api`

**Output**

```json
{
  "id": 123,
  "name": "test_job",
  "status": "STARTED"
}
```
