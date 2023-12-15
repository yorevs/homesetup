<img src="https://iili.io/HvtxC1S.png" width="64" height="64" align="right" />

# HomeSetup Developer Handbook
>
> Applications handbook

## Table of contents

<!-- toc -->

- [Bash Applications](../../../../applications)
  - [Check-IP](../../check-ip#check-ip)
  - [Fetch](../../fetch#fetch)
  - [HHS-App](../../hhs-app#homesetup-application)
    - [Functions](../../hhs-app#functions)
      - [Built-Ins](built-ins)
      - [Misc](misc)
      - [Tests](tests)
      - [Web](web)
    - [Plugins](../../hhs-app#plug-ins)
      - [Firebase](../plugins/firebase)
      - [HSPM](../plugins/hspm)
      - [Settings](../plugins/settings)
      - [Setup](../plugins/setup)
      - [Starship](../plugins/starship)
      - [Updater](../plugins/updater)

<!-- tocstop -->

## Miscellaneous

### "host-name"

```bash
Usage: hhs host-name [new_hostname]
```

### **Purpose**

Retrieve/Get/Set the current hostname.

### **Returns**

**0** if the hostname was successfully changed/retrieved; **non-zero** otherwise.

### **Parameters**

- $1 _Optional_ : The new hostname. If not provided, current hostname is retrieved.

### **Examples**

`hhs host-name my.domain.hostname`

**Output**

```bash

```

`hhs host-name && echo 'This is the current hostname'`

```bash

```
