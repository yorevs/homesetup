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

## Check-IP application

```bash
Usage:  [Options] <ip_address>

    Options:
      -q | --quiet  : Silent mode. Do not check for IP details.
      -i | --info   : Fetch additional information from the web.
```

##### **Purpose**:

Validate and check information about a provided IP address.

##### **Returns**:

**0** if the IP is valid; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The IP address.

##### **Examples:**

```bash
  $ check-ip.bash 192.168.0.10
  $ check-ip.bash -i 192.158.100.10
```
