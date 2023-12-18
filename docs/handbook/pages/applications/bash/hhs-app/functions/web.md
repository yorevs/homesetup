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

### "docsify"

```bash
Usage: __hhs docsify
```

#### **Purpose**

Open a docsify version of the HomeSetup README.

#### **Returns**

**0** if the command was successfully executed; **non-zero** otherwise.

#### **Examples**

`__hhs docsify`

**Output**

```bash
Opening HomeSetup docsify README from: https://docsify-this.net/?basePath=https://raw.githubusercontent.com/yorevs/homesetup/master&sidebar=true
```

------

## Web

### "board"

```bash
Usage: __hhs board
```

#### **Purpose**

Open the HomeSetup GitHub project board.

#### **Returns**

**0** if the command was successfully executed; **non-zero** otherwise.

#### **Examples**

`__hhs board`

**Output**

```bash
Opening HomeSetup board from: https://github.com/yorevs/homesetup/projects/1
```
