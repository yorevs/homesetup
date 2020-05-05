# HomeSetup Search Related Functions Handbook

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
