# <img src="https://iili.io/HvtxC1S.png"  width="34" height="34"> HomeSetup Standard-Tools Functions Handbook

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


### Paths tool

### __hhs_paths

```bash
Usage: __hhs_paths [options] <args>

    Options:
      -a <path> : Add to the current <path> to PATH.
      -r <path> : Remove from the current <path> from PATH.
      -e        : Edit current HHS_PATHS_FILE.
      -c        : Attempt to clear non-existing paths. System paths are not affected.
      -q        : Quiet mode on.

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
