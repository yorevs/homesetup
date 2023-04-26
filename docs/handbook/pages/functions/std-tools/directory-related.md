# HomeSetup Directory Related Functions Handbook

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


### Directory related functions

#### __hhs_change_dir

```bash
Usage: __hhs_change_dir [-L|-P] [dir]

    Options:
        [dir]   : The directory to change. If not provided, default DIR is the value of the HOME variable.
        -L      : Force symbolic links to be followed.
        -P      : Use the physical directory structure without following symbolic links.
```

##### **Purpose**:

# HomeSetup Standard-Tools Functions Handbook

##### **Returns**:

**0** if the directory is changed; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Optional_ : [-L|-P] whether to follow (-L) or not (-P) symbolic links.
  - $2 _Optional_ : The directory to change. If not provided, default DIR is the value of the HOME variable.

##### **Examples:**

```bash
  $ __hhs_change_dir /tmp && echo "Directory changed to /tmp"
```


------
#### __hhs_changeback_ndirs

```bash
Usage: __hhs_changeback_ndirs [ndirs]

    Options:
        [ndirs]   : The number of directories to change backwards.
```

##### **Purpose**:

Change the current working directory to the previous folder by N times.

##### **Returns**:

**0** if directory is changed; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Optional_ : The number of directories to change backwards. If not provided, default is one.

##### **Examples:**

```bash
  $ .. && echo "Changed to the previous directory `pwd`"
  $ .. 3 && echo "Changed backwards to 3rd previous directory `pwd`"
```


------
#### __hhs_dirs

```bash
Usage: __hhs_dirs
```

##### **Purpose**:

Display the list of currently selectable remembered directories.

##### **Returns**:

**0** if directory is changed; **non-zero** otherwise.

##### **Parameters**: 

  - $N _Optional_ : If any parameter is used, the default dirs command is invoked instead.

##### **Examples:**

```bash
  $ __hhs_dirs
```


------
#### __hhs_list_tree

```bash
Usage: __hhs_list_tree [from_dir] [recurse_level]
```

##### **Purpose**:

List contents of directories in a tree-like format.

##### **Returns**:

**0** on success ; **non-zero** otherwise.

##### **Parameters**: -


##### **Examples:**

```bash
  $ __hhs_list_tree . 5
  $ __hhs_list_tree /tmp 2
  $ __hhs_list_tree /Users
```


------
#### __hhs_save_dir

```bash
Usage: __hhs_save_dir -e | [-r] <dir_alias> | <dir_to_save> <dir_alias>

Options:
    -e : Edit the saved dirs file.
    -r : Remove saved dir.
```

##### **Purpose**:

Save one directory path for future __hhs_load.

##### **Returns**:

**0** if the save was successful; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Conditional_ : The directory path to save or the alias to be removed.
  - $2 _Conditional_ : The alias to name the saved path.

##### **Examples:**

```bash
  $ __hhs_save_dir . dot && echo "Directory . saved as dot"
  $ __hhs_save_dir -r dot && echo "Directory dot removed"
```


------
#### __hhs_load_dir

```bash
Usage: __hhs_load_dir [-l] | [dir_alias]

Options:
    [dir_alias] : The alias to load the path from.
             -l : List all saved dirs.

  Notes:
    MSelect default : When no arguments are provided, a menu with options will be displayed.
```

##### **Purpose**:

Change the current working directory to pre-saved entry from __hhs_save.

##### **Returns**:

**0** if the load was successful; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Optional_ : The alias to load the path from.

##### **Examples:**

```bash
  $ __hhs_load_dir dot
  $ __hhs_load_dir -l
```


------
#### __hhs_godir

```bash
Usage: __hhs_godir [search_path] <dir_name>
```

##### **Purpose**:

Search and cd into the first match of the specified directory name.

##### **Returns**:

**0** if directory is changed; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Optional_ : The base search path.
  - $2 _Required_ : The directory name to search and cd into.

##### **Examples:**

```bash
  $ __hhs_godir /usr bin && echo "Entered the bin directory"
  $ __hhs_godir bin && echo "Entered the bin directory"
```


------
#### __hhs_mkcd

```bash
Usage: __hhs_mkcd <dirtree | package> 

E.g:. __hhs_mkcd dir1/dir2/dir3 (dirtree)
E.g:. __hhs_mkcd dir1.dir2.dir3 (FQDN)
```

##### **Purpose**:

Create all folders using a slash or dot notation path and immediately change into it.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The directory tree or the package name

##### **Examples:**

```bash
  $ __hhs_mkcd dir1/dir2/dir3 && echo "Changed to dir3: $(pwd)"
  $ __hhs_mkcd br.edu.hhs && echo "Changed to hhs: $(pwd)"
```
