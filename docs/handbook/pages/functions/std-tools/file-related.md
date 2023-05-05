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
- [Development Tools](../../functions.md#development-tools)
  * [Gradle](../dev-tools/gradle-tools.md#gradle-functions)
  * [Docker](../dev-tools/docker-tools.md#docker-functions)
  * [Git](../dev-tools/git-tools.md#git-functions)
<!-- tocstop -->


### File related functions

#### __hhs_ls_sorted

```bash
Usage: __hhs_ls_sorted [column_number]

  Columns:
    1 : First column gives the type of the file/dir and the file permissions.
    2 : Second column is the number of links to the file/dir.
    3 : Third column is the user who owns the file.
    4 : Fourth column is the Unix group of users to which the file belongs.
    5 : Fifth column is the size of the file in bytes.
    6 : Sixth column is the Month at which the file was last changed.
    7 : Seventh column is the Day at which the file was last changed.
    8 : Eighth column is the Year or Time at which the file was last changed.
    9 : The last column is the name of the file.
```

##### **Purpose**:

List files sorted by the specified column. The following columns apply:

|      1      |      2      |     3      |      4      |   5   |     6      |    7     |     8     |  9   |
|:-----------:|:-----------:|:----------:|:-----------:|:-----:|:----------:|:--------:|:---------:|:----:|
| Permissions | Link Count  | Owner User | Owner Group | Size  | L.M. Month | L.M. Day | L.M. Time | Name |

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Optional_ : The listed column number

##### **Examples:**

```bash
  $ __hhs_ls_sorted 8 && echo "Files sorted by last modified time"
  $ __hhs_ls_sorted && echo "Files sorted by default column: Name"
```


------
#### __hhs_del_tree

```bash
Usage: __hhs_del_tree [-n|-f] <search_path> <glob_expr>

  Options:
    -n | --dry-run  : Dry run. Don\'t actually remove anything, just show what would be done.
    -f | --force    : Actually delete all files/directories it finds.
```

##### **Purpose**:

Move files recursively to the Trash.

##### **Returns**:

**0** if command was successful; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : Base search path.
  - $2 _Required_ : The glob expression to match the file/dir names.


##### **Examples:**

```bash
  $ __hhs_del_tree . '.DS_Store' && echo "Would not delete since default is dry run"
  $ __hhs_del_tree -f . '.DS_Store' && echo "Would delete all .DS_Store it finds"
```
