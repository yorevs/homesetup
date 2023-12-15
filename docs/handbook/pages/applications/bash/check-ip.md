<img src="https://iili.io/HvtxC1S.png" width="64" height="64" align="right" />

# HomeSetup Developer Handbook
>
> Applications handbook

## Table of contents

<!-- toc -->

- [Bash Applications](../../applications)
  - [Check-IP](check-ip#check-ip)
  - [Fetch](fetch#fetch)
  - [HHS-App](hhs-app#homesetup-application)
    - [Functions](hhs-app#functions)
      - [Built-Ins](hhs-app/functions/built-ins)
      - [Misc](hhs-app/functions/misc)
      - [Tests](hhs-app/functions/tests)
      - [Web](hhs-app/functions/web)
    - [Plugins](hhs-app#plug-ins)
      - [Firebase](hhs-app/plugins/firebase)
      - [HSPM](hhs-app/plugins/hspm)
      - [Settings](hhs-app/plugins/settings)
      - [Setup](hhs-app/plugins/setup)
      - [Starship](hhs-app/plugins/starship)
      - [Updater](hhs-app/plugins/updater)

<!-- tocstop -->

## Check-IP

```bash
Usage:  [Options] <ip_address>

    Options:
      -q | --quiet  : Silent mode. Do not check for IP details.
      -i | --info   : Fetch additional information from the web.
```

### **Purpose**

Validate and check information about a provided IP address.

### **Returns**

**0** if the IP is valid; **non-zero** otherwise.

### **Parameters**

- $1 _Required_ : The IP address.

### **Examples:**

`check-ip.bash 192.168.0.10`

**Output**

```bash
Valid IP: 192.168.0.10, Class: C, Scope: Private
```

`check-ip.bash -i 192.158.100.10`

**Output**

```bash
Valid IP: 192.158.100.10, Class: C, Scope: Public
{
    "status": "success",
    "country": "United States",
    "countryCode": "US",
    "region": "OR",
    "regionName": "Oregon",
    "city": "Beaverton",
    "zip": "97077",
    "lat": 45.4991,
    "lon": -122.823,
    "timezone": "America/Los_Angeles",
    "isp": "Tektronix",
    "org": "Tektronix, Inc",
    "as": "",
    "query": "192.158.100.10"
}
```
