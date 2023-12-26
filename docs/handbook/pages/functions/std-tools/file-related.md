<img src="https://iili.io/HvtxC1S.png" width="64" height="64" align="right" />

# HomeSetup Developer Handbook
>
> Standard-Tools

## Table of contents

<!-- toc -->

- [Standard Tools](../../functions.md#standard-tools)
  - [Aliases Related](aliases-related.md#aliases-related-functions)
  - [Built-ins](built-ins.md#built-ins-functions)
  - [CLI Terminal Tools](clitt.md#cli-terminal-tools)
  - [Command Tool](command-tool.md#command-tool)
  - [Directory Related](directory-related.md#directory-related-functions)
  - [File Related](file-related.md#file-related-functions)
  - [Network Related](network-related.md#network-related-functions)
  - [Paths Tool](paths-tool.md#paths-tool)
  - [Profile Related](profile-related.md#profile-related-functions)
  - [Search Related](search-related.md#search-related-functions)
  - [Security Related](security-related.md#security-related-functions)
  - [Shell Utilities](shell-utilities.md#shell-utilities)
  - [System Utilities](system-utilities.md#system-utilities)
  - [Taylor Tool](taylor-tool.md#taylor-tool)
  - [Text Utilities](text-utilities.md#text-utilities)
  - [TOML Utilities](toml-utilities.md#toml-utilities)
  - [Toolchecks](toolchecks.md#tool-checks-functions)
- [Development Tools](../../functions.md#development-tools)
  - [Gradle](../dev-tools/gradle-tools.md#gradle-functions)
  - [Docker](../dev-tools/docker-tools.md#docker-functions)
  - [Git](../dev-tools/git-tools.md#git-functions)

<!-- tocstop -->

### File related functions

#### __hhs_ls_sorted

```bash
Usage: __hhs_ls_sorted [column_name] [-reverse]

  Columns:
    type  : First column gives the type of the file/dir and the file permissions.
    links : Second column is the number of links to the file/dir.
    user  : Third column is the user who owns the file.
    group : Fourth column is the Unix group of users to which the file belongs.
    size  : Fifth column is the size of the file in bytes.
    month : Sixth column is the Month at which the file was last changed.
    day   : Seventh column is the Day at which the file was last changed.
    time  : Eighth column is the Year or Time at which the file was last changed.
    name  : The last column is the name of the file.


  Notes:
    - If -reverse is specified, reverse the order or sorting
```

##### **Purpose**

List files sorted by the specified column. The following columns apply:

|  1   |   2   |   3   |   4   |  5   |     6      |    7     |     8     |  9   |
|:----:|:-----:|:-----:|:-----:|:----:|:----------:|:--------:|:---------:|:----:|
| Type | Links | Owner | Group | Size | L.M. Month | L.M. Day | L.M. Time | Name |

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Optional_ : The listed column name.

##### **Examples**

`__hhs_ls_sorted time`

**Output**

```bash
   rw-r--r--    1   hjunior   staff     11 KiB   Tue Dec 26 15:45:09 2023    README.md
   rwxr-xr-x    6   hjunior   staff    192 B     Fri Dec 22 19:09:51 2023    dotfiles/
   rwxr-xr-x    1   hjunior   staff     33 KiB   Fri Dec 22 18:56:39 2023    install.bash
   rwxr-xr-x   11   hjunior   staff    352 B     Fri Dec 22 18:51:32 2023    docs/
   rwxr-xr-x    7   hjunior   staff    224 B     Fri Dec 22 18:31:43 2023    bin/
   rwxr-xr-x   11   hjunior   staff    352 B     Fri Dec 22 18:28:28 2023    assets/
   rw-r--r--    1   hjunior   staff   1007 B     Fri Dec 22 15:31:00 2023    check-badge.svg
   rwxr-xr-x    1   hjunior   staff      6 KiB   Thu Dec 21 18:41:22 2023    uninstall.bash
   rwxr-xr-x    6   hjunior   staff    192 B     Thu Dec 21 17:07:07 2023    templates/
   rw-r--r--    1   hjunior   staff    410 B     Thu Dec 21 16:39:59 2023    _config.yml
   rwxr-xr-x    7   hjunior   staff    224 B     Tue Dec 12 15:00:10 2023    docker/
   rwxr-xr-x    7   hjunior   staff    224 B     Thu Dec  7 14:40:20 2023    tests/
   rw-r--r--    1   hjunior   staff     90 B     Mon Nov 27 17:30:48 2023    gradle.properties
   rw-r--r--    1   hjunior   staff    372 B     Mon Nov 27 17:30:48 2023    bumpver.toml
   rwxr-xr-x    6   hjunior   staff    192 B     Thu Sep 21 15:23:33 2023    gradle/
   rw-r--r--    1   hjunior   staff    945 B     Thu Sep 21 12:39:52 2023    build.gradle
   rw-r--r--    1   hjunior   staff      1 KiB   Tue Sep 19 17:45:16 2023    LICENSE.md
   rwxr-xr-x    1   hjunior   staff      7 KiB   Tue Sep 19 17:08:09 2023    gradlew
   rw-r--r--    1   hjunior   staff     31 B     Tue Sep 19 13:25:01 2023    settings.gradle
   rw-r--r--    1   hjunior   staff    150 B     Fri Aug 25 15:51:27 2023    homesetup.code-workspac
```

------

#### __hhs_del_tree

```bash
Usage: __hhs_del_tree [-n|-f|-i] <search_path> <glob_expr>

  Options:
    -n | --dry-run      : Just show what would be deleted instead of removing it.
    -f | --force        : Actually delete all files/directories it finds.
    -i | --interactive  : Interactive deleting files/directories.

  Notes:
    - If no option is specified, dry-run is default.
```

##### **Purpose**

Move files recursively to the Trash.

##### **Returns**

**0** if command was successful; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_ : The GLOB expression of the file/directory search.

##### **Examples**

`__hhs_del_tree . '.DS_Store'`

```bash
Would delete -> ./.DS_Store
Would delete -> ./docs/handbook/pages/functions/.DS_Store
Would delete -> ./assets/.DS_Store
```
