# HomeSetup Standard-Tools Functions Handbook

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
- [Development Tools](../../functions.md#development-tools)
  * [Gradle](../dev-tools/gradle-tools.md)
  * [Docker](../dev-tools/docker-tools.md)
  * [Git](../dev-tools/git-tools.md)
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
