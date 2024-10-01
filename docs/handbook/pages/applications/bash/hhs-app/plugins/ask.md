<img src="https://iili.io/HvtxC1S.png" width="64" height="64" align="right" />

# HomeSetup Developer Handbook
>
> Applications handbook

## Table of contents

<!-- toc -->

- [Bash Applications](../../../../applications.md)
  - [Check-IP](../../check-ip.md#check-ip)
  - [Fetch](../../fetch.md#fetch)
  - [HHS-App](../../hhs-app.md#homesetup-application)
    - [Functions](../../hhs-app.md#functions)
      - [Built-Ins](../functions/built-ins.md)
      - [Misc](../functions/misc.md)
      - [Tests](../functions/tests.md)
      - [Web](../functions/web.md)
    - [Plugins](../../hhs-app.md#plug-ins)
      - [Firebase](firebase.md)
      - [HSPM](hspm.md)
      - [Settings](settings.md)
      - [Setup](setup.md)
      - [Starship](starship.md)
      - [Updater](updater.md)
      - [Ask](ask.md)

<!-- tocstop -->

## Updater

### "help"

#### **Purpose**

HomeSetup AI integration.

#### **Returns**

**0** if the command was successfully executed; **non-zero** otherwise.

#### **Parameters**

- $1..$N _Required_ : The question about HomeSetup.

#### **Examples**

`__hhs ask execute How can I use starship?`

**Output**

```bash
  Taius: You can use Starship by executing commands in your terminal. Here are some examples:

 1 To set a specific preset for your Starship prompt:

    __hhs starship execute preset 'no-nerd-font'

   This changes your Starship prompt to the "no-nerd-font" preset.
 2 To view help information about Starship commands:

    __hhs starship help

   This will display usage information and available commands.
 3 To edit your Starship configuration file:

    __hhs starship edit

 4 To restore HomeSetup defaults:

    __hhs starship restore


For more detailed information, you can refer to the HomeSetup Developer Handbook, specifically the section on Starship. You can also visit the Starship website at [starship.rs]( https://starship.rs/).
```
