# HomeSetup Paths Tool Handbook

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


### Paths tool

### __hhs_paths

```bash
Usage: __hhs_paths [options] <args>

    Options:
      -a <path> : Add to the current <path> to PATH.
      -r <path> : Remove from the current <path> from PATH.
      -e        : Edit current HHS_PATHS_FILE.
      -c        : Attempt to clears non-existing paths. System paths are not affected
      -q        : Quiet mode on

  Notes:
    When no arguments are provided it will list all PATH entries
```

##### **Purpose**:

Manage your custom PATH entries. To add to your PATH, the directory must be a valid directory path.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Conditional_     : The path to be added or removed.

##### **Examples:**

```bash
  $ __hhs_paths -a /tmp && echo "/tmp added to your custom PATH"
  $ __hhs_paths -r /tmp && echo "/tmp removed from your custom PATH"
  $ __hhs_paths -c && echo "Cleaned up invalid custom PATHs"
```
