# HomeSetup Punch Tool Handbook

## Table of contents

<!-- toc -->
- [Standard Tools](../../functions.md#standard-tools)
  * [General](general.md)
  * [Aliases Related](aliases-related.md)
  * [Built-ins](built-ins.md)
  * [Command Tool](command-tool.md)
  * [Directory Related](directory-related.md)
  * [File Related](file-related.md)
  * [MChoose Tool](mchoose-tool.md)
  * [MInput Tool](minput-tool.md)
  * [MSelect Tool](mselect-tool.md)
  * [Network Related](network-related.md)
  * [Paths Tool](paths-tool.md)
  * [Profile Related](profile-related.md)
  * [Punch-Tool](punch-tool.md)
  * [Search Related](search-related.md)
  * [Security Related](security-related.md)
  * [Shell Utilities](shell-utilities.md)
  * [System Utilities](system-utilities.md)
  * [Taylor Tool](taylor-tool.md)
  * [Text Utilities](text-utilities.md)
  * [Toolchecks](toolchecks.md)
- [Development Tools](../../functions.md#development-tools)
  * [Gradle](../dev-tools/gradle-tools.md)
  * [Docker](../dev-tools/docker-tools.md)
  * [Git](../dev-tools/git-tools.md)
<!-- tocstop -->


### Punch tool

### __hhs_punch

```bash
Usage: __hhs_punch [options] <args>

    Options:
      -l        : List all registered punches.
      -e        : Edit current punch file.
      -r        : Reset punches for the current week and save the previous one.
      -w <week> : Report (list) all punches of specified week using the pattern: week-N.punch.

  Notes:
    When no arguments are provided it will !!PUNCH THE CLOCK!!.
```

##### **Purpose**:

PUNCH-THE-CLOCK. This is a helper tool to aid with the timesheets.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Conditional_     : The week list punches from.

##### **Examples:**

```bash
  $ __hhs_punch && echo "I just punched the clock"
  $ __hhs_punch -l && echo "Thats all current week's punches"
  $ __hhs_punch -w 15 && echo "Listing week 16 punches"
```
