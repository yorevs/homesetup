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
  * [MChoose Tool](clitt.md#mchoose-tool)
  * [MInput Tool](clitt.md#minput-tool)
  * [MSelect Tool](clitt.md#mselect-tool)
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
  * [Docker](../dev-tools/docker-tools.md#docker-functions)
  * [Gradle](../dev-tools/gradle-tools.md#gradle-functions)
  * [Git](../dev-tools/git-tools.md#git-functions)
<!-- tocstop -->


### Search related functions

### __hhs_search_file

```bash
Usage: __hhs_search_file <search_path> <globs...>

  Notes:
    ** <globs...>: Comma separated globs. E.g: "*.txt,*.md,*.rtf"
```

##### **Purpose**:

Search for files and links to files recursively.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_     : The base search path.
  - $2 _Required_     : The search glob expressions.

##### **Examples:**

```bash
  $ __hhs_search_file /var/log '*.log'
  $ __hhs_search_file . '*.properties,*.yaml'
```

------
### __hhs_search_dir

```bash
Usage: __hhs_search_dir <search_path> <dir_names...>

  Notes:
  ** <dir_names...>: Comma separated directories. E.g:. "dir1,dir2,dir2"
```

##### **Purpose**:

Search for directories and links to directories recursively.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_     : The base search path.
  - $2 _Required_     : The search glob expressions.

##### **Examples:**

```bash
  $ __hhs_search_dir /tmp 'com*'
  $ __hhs_search_dir . 'java*,resources*'
```

------
### __hhs_search_string

```bash
Usage: __hhs_search_string [options] <search_path> <regex/string> <globs>

    Options:
      -i | --ignore-case            : Makes the search case INSENSITIVE.
      -w | --words                  : Makes the search to use the STRING words instead of a REGEX.
      -r | --replace <replacement>  : Makes the search to REPLACE all occurrences by the replacement string.
      -b | --binary                 : Includes BINARY files in the search.

  Notes:
    ** <globs...>: Comma separated globs. E.g: "*.txt,*.md,*.rtf"
```

##### **Purpose**:

Search in files for strings matching the specified criteria recursively.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_     : The base search path.
  - $2 _Required_     : The search expression. Can be a regex or just a string.
  - $3 _Required_     : The search glob expressions.

##### **Examples:**

```bash
  $ __hhs_search_string /var/log 'apple' '*.log'
  $ __hhs_search_string . 'server.port' '*.properties,*.yaml'
  $ __hhs_search_string -r 'server.port = 1234' . 'server.port *= *.*' '*.properties,*.yaml'
```
