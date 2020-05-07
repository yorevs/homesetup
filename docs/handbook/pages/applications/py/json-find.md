# HomeSetup Applications Handbook

## Table of contents

<!-- toc -->
- [Bash Apps](../../applications.md#bash-apps)
  * [App-Commons](../bash/app-commons.md)
  * [Check-IP](../bash/check-ip.md)
  * [Fetch](../bash/fetch.md)
  * [HHS-App](../bash/hhs-app.md)
- [Python Apps](../../applications.md#python-apps)
  * [Free](free.md)
  * [Json-Find](json-find.md)
  * [PPrint-xml](pprint-xml.md)
  * [Print-Uni](print-uni.md)
  * [Send-Msg](send-msg.md)
  * [TCalc](tcalc.md)
<!-- tocstop -->

## Json-Find application

```bash
Find a json path from a json string

Usage: json-find.py -f <filename> -a <search_path>
```

##### **Purpose**:

Find an object from the json string or json file.

##### **Returns**:

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The json filename.
  - $2 _Required_ : The search_path to be found.

##### **Examples:**

```bash
  $ json-find.py -f lib/hhslib/jsonutils/tests/resources/json_utils_sample.json -a elem3
```
