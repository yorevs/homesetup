# <img src="https://iili.io/HvtxC1S.png"  width="34" height="34"> HomeSetup Applications Handbook

## Table of contents

<!-- toc -->

- [Bash Applications](../../applications.md)
  - [App-Commons](app-commons.md#application-commons)
  - [Check-IP](check-ip.md#check-ip-application)
  - [Fetch](fetch.md#fetch-application)
  - [HHS-App](hhs-app.md#homesetup-application)
    - [Functions](hhs-app.md#functions)
    - [Plugins](hhs-app.md#plug-ins)
      - [Firebase](hhs-app.md#firebase)
      - [HSPM](hhs-app.md#hspm)
      - [Settings](hhs-app.md#settings)
      - [Setup](hhs-app.md#setup)
      - [Starship](hhs-app.md#starship)
      - [Updater](hhs-app.md#updater)

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
