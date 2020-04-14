# HomeSetup Functions Handbook

## Standard tools


------
### __hhs_has

```bash
Usage: __hhs_has <command>
```

##### **Purpose**:

Check if a command is available on the current shell session.

##### **Returns**:

'0' : If the command is available, '1' otherwise

##### **Parameters**:

  - $1 _Required_ : The command to check.

##### **Examples:**

```bash
  $ __hhs_has ls && echo "ls is installed"
  $ __hhs_has noexist || echo "ls is not installed"
```


------
### __hhs_alias

```bash
Usage: __hhs_alias <alias_name>='<alias_expr>'
```

##### **Purpose**:

Check if an alias does not exists and create it, otherwise just ignore it. Do not support the use of single quotes in the expression.

##### **Returns**:

**0** if the alias name was created (available); **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The alias to set/check.
  - $* _Required_ : The alias expression.

##### **Examples:**

```bash
  $ __hhs_alias ls='ls -la' || echo "Alias was not created !"
  $ __hhs_alias noexist='ls -la' || echo "Alias was created !"
```


------
### __hhs_aliases

```bash
Usage: __hhs_aliases [-s|--sort] [alias <alias_expr>]

    Options: 
      -e | --edit    : Open the aliases file for editting.
      -s | --sort    : Sort results ASC.
      -r | --remove  : Remove an alias.

  Notes: 
    List all aliases    : When [alias_expr] is NOT provided. If [alias] is provided, filter restuls using it.
    Add/Set an alias    : When both [alias] and [alias_expr] are provided.
```

##### **Purpose**:

Manipulate custom aliases (add/remove/edit/list).

##### **Returns**:

**0** if the alias was created (available); **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Optional_ : The alias name.
  - $2 _Conditional_ : The alias expression.

##### **Examples:**

```bash
  $ __hhs_aliases my-alias 'ls -la' && echo "Alias created"
  $ __hhs_aliases my-alias && echo "Alias removed"
  $ __hhs_aliases -s && echo "Listing all sorted aliases"
```


------
### __hhs_random_number

```bash
Usage: __hhs_random_number <min-val> <max-val>
```

##### **Purpose**:

Generate a random number int the range <min> <max> (all limits included).

##### **Returns**:

**0** if the number was generated; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The minimum range of the number.
  - $2 _Required_ : The maximum range of the number.

##### **Examples:**

```bash
  $ __hhs_random_number 0 10 && echo "Random from 0 to 10"
```


------
### __hhs_ascof
```bash
Usage: __hhs_ascof <character>
```

##### **Purpose**:

Display the decimal ASCII representation of a character.

##### **Returns**:

**0** if the representation was displayed; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The character to display.

##### **Examples:**

```bash
  $ __hhs_ascof H && echo "Thats the ascii representation of H"
```


------
### __hhs_utoh
```bash
Usage: __hhs_utoh <unicode...>

  Notes: unicode is a four digits hexadecimal
```

##### **Purpose**:

Convert unicode to hexadecimal

##### **Returns**:

**0** if the unicode was successfully converted; **non-zero** otherwise.

##### **Parameters**: 

  - $1..$N _Required_ : The unicode values to convert

##### **Examples:**

```bash
  $ __hhs_utoh f123 f321 && echo "Thats the hexadecimal representation of the unicode valus f123 and f321"
```


------
### __hhs_command
```bash
Usage: __hhs_command [options [cmd_alias] <cmd_expression>] | [cmd_index]

    Options:
      [cmd_index]   : Execute the command specified by the command index.
      -e | --edit   : Edit the commands file.
      -a | --add    : Store a command.
      -r | --remove : Remove a command.
      -l | --list   : List all stored commands.

  Notes:
    MSelect default : When no arguments is provided, a menu with options will be displayed.
```

##### **Purpose**:

Add/Remove/List/Execute saved bash commands.

##### **Returns**:

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Optional_ : The command index or alias.
  - $2..$N _Conditional_ : The command expression. This is required when alias is provided.

##### **Examples:**

```bash
  $ __hhs_command -a test ls -la && echo "Created a test command"
  $ __hhs_command test && echo "Executed ls -la"
  $ __hhs_command -r test && echo "Removed a test command"
```


------
### __hhs_change_dir
```bash
Usage: __hhs_change_dir [-L|-P] [dir]

    Options:
        [dir]   : The directory to change. If not provided, default DIR is the value of the HOME variable.
        -L      : Force symbolic links to be followed.
        -P      : Use the physical directory structure without following symbolic links.
```

##### **Purpose**:

Change the current working directory to a specific Folder.

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
### __hhs_changeback_ndirs
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
### __hhs_dirs
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
### __hhs_list_tree
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
### __hhs_save_dir
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
### __hhs_load_dir
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
### __hhs_godir
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
### __hhs_mkcd
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


------
### __hhs_ls_sorted
```bash
Usage: __hhs_ls_sorted [column_number]
```

##### **Purpose**:

List files sorted by the specified column. The following columns apply:

|      1      |      2      |      3     |      4      |   5   |     6      |    7     |     8     |  9   |
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
### __hhs_del_tree
```bash
Usage: __hhs_del_tree [-n|-f] <search_path> <glob_expr>

  Options:
    -n | --dry-run  : Dry run. Don\'t actually remove anything, just show what would be done.
    -f | --force    : Actually delete all files/directories it finds.
```

##### **Purpose**:

Move files recursively to the Trash.

##### **Returns**:

**0** if command was successfull; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : Base search path.
  - $2 _Required_ : The glob expression to match the file/dir names.


##### **Examples:**

```bash
  $ del-tree . '.DS_Store' && echo "Would not delete since default is dry run"
  $ del-tree -f . '.DS_Store' && echo "Would delete all .DS_Store it finds"
```










------
### __hhs
```bash
Usage: 
```

##### **Purpose**:

TODO

##### **Returns**:

**0** if TODO; **non-zero** otherwise.

##### **Parameters**: 

TODO


##### **Examples:**

```bash
  $ example here
```




------
## Development tools

TODO
