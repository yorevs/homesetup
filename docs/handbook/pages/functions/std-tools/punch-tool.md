# HomeSetup Standard-Tools Functions Handbook

## Table of contents

<!-- toc -->
- [Standard Tools](../../functions.md#standard-tools)
  * [General](general.md#general-functions)
  * [Aliases Related](aliases-related.md#aliases-related-functions)
  * [Built-ins](built-ins.md#built-ins-functions)
  * [Command Tool](command-tool.md#command-tool)
  * [Directory Related](directory-related.md#directory-related-functions)
  * [File Related](file-related.md#file-related-functions)
  * [MChoose Tool](mchoose-tool.md#mchoose-tool)
  * [MInput Tool](minput-tool.md#minput-tool)
  * [MSelect Tool](mselect-tool.md#mselect-tool)
  * [Network Related](network-related.md#network-related-functions)
  * [Paths Tool](paths-tool.md#paths-tool)
  * [Profile Related](profile-related.md#profile-related-functions)
  * [Punch-Tool](punch-tool.md#punch-tool)
  * [Search Related](search-related.md#search-related-functions)
  * [Security Related](security-related.md#security-related-functions)
  * [Shell Utilities](shell-utilities.md#shell-utilities)
  * [System Utilities](system-utilities.md#system-utilities)
  * [Taylor Tool](taylor-tool.md#taylor-tool)
  * [Text Utilities](text-utilities.md#text-utilities)
  * [Toolchecks](toolchecks.md#tool-checks-functions)
- [Development Tools](../../functions.md#development-tools)
  * [Gradle](../dev-tools/gradle-tools.md#gradle-functions)
  * [Docker](../dev-tools/docker-tools.md#docker-functions)
  * [Git](../dev-tools/git-tools.md#git-functions)
<!-- tocstop -->


### Punch tool

### __hhs_punch

```bash
Usage: __hhs_punch [options] <args>

    Options: 
      -l | --list       : List all registered punches.
      -e | --edit       : Edit current punch file.
      -r | --reset      : Reset punches for the current week and save the previous one.
      -w | --week <num> : Report (list) all punches of specified week using the pattern: week-N.punch.

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
