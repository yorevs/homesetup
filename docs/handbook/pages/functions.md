# HomeSetup Functions Handbook

## Table of contents

<!-- toc -->
- [Standard Tools](#standard-tools)
  * [General](#general)
  * [Aliases Related](#aliases-related)
  * [Built-ins](#built-ins)
  * [Command Tool](#command-tool)
  * [Directory Related](#directory-related)
  * [File Related](#file-related)
  * [MChoose Tool](#mchoose-tool)
  * [MInput Tool](#minput-tool)
  * [MSelect Tool](#mselect-tool)
  * [Network Related](#network-related)
  * [Paths Tool](#paths-tool)
  * [Profile Related](#profile-related)
  * [Punch-Tool](#punch-tool)
  * [Search Related](#search-related)
  * [Security Related](#security-related)
  * [Shell Utilities](#shell-utilities)
  * [System Utilities](#system-utilities)
  * [Taylor Tool](#taylor-tool)
  * [Text Tool](#text-tool)
  * [Toolchecks](#toolchecks)
- [Development Tools](#development-tools)
<!-- tocstop -->

## Standard Tools

### General

#### __hhs_has

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

### Aliases Related

#### __hhs_alias

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
#### __hhs_aliases

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


### Built-ins

#### __hhs_random_number

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
#### __hhs_ascof

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
#### __hhs_utoh

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


### Command Tool

#### __hhs_command

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


### Directory Related

#### __hhs_change_dir

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


### File Related

#### __hhs_ls_sorted

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

**0** if command was successfull; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : Base search path.
  - $2 _Required_ : The glob expression to match the file/dir names.


##### **Examples:**

```bash
  $ __hhs_del_tree . '.DS_Store' && echo "Would not delete since default is dry run"
  $ __hhs_del_tree -f . '.DS_Store' && echo "Would delete all .DS_Store it finds"
```


### MChoose Tool

#### __hhs_mchoose

```bash
Usage: __hhs_mchoose [options] <output_file> <items...>

    Options:
      -c  : All options are initially checked instead of unchecked.

    Arguments:
      output_file : The output file where the results will be stored.
      items       : The items to be displayed for choosing.

    Examples:
      Choose numbers from 1 to 20 (start with all options checked):
        => __hhs_mchoose /tmp/out.txt {1..20} && cat /tmp/out.txt
      Choose numbers from 1 to 20 (start with all options unchecked):
        => __hhs_mchoose -c /tmp/out.txt {1..20} && cat /tmp/out.txt

  Notes:
    - A temporary file is suggested to used with this command: $ mktemp.
    - The outfile must not exist or it be an empty file.
```

##### **Purpose**:

Choose options from a list using a navigable menu.

##### **Returns**:

  - **0** on success and if chosen items were Accepted.
  - **127** if the user Canceled (**Q** pressed).
  - **non-zero** for all other cases.

##### **Parameters**: 

  - $1 _Required_     : The output file where the results will be stored.
  - $2..$N _Required_ : The items to be displayed for choosing.

##### **Examples:**

```bash
  $ __hhs_mchoose /tmp/out.txt {1..20} && echo "All options initially unchecked" && cat /tmp/out.txt
  $ __hhs_mchoose -c /tmp/out.txt {1..20} && echo "All options initially checked" && cat /tmp/out.txt
```


### MInput Tool

#### __hhs_minput

```bash
Usage: __hhs_minput <output_file> <fields...>

    Arguments:
      output_file : The output file where the results will be stored.
        fields    : A list of form fields: Label|Mode|Type|Min/Max len|Perm|Value

    Fields:
            <Label> : The field label. Consisting only of alphanumeric characters and under‐scores.
             [Mode] : The input mode. One of {[input]|password|checkbox}.
             [Type] : The input type. One of {letter|number|alphanumeric|[any]}.
      [Min/Max len] : The minimum and maximum length of characters allowed. Defauls to [0/30].
             [Perm] : The field permissions. One of {r|[rw]}. Where \"r\" for Read Only ; \"rw\" for Read & Write.
            [Value] : The initial value of the field. This field may not be blank if the field is read only.

    Examples:
      Form with 4 fields (Name,Age,Password,Role,Accept_Conditions):
        => __hhs_minput /tmp/out.txt 'Name|||5/30|rw|' 'Age||number|1/3||' 'Password|password||5|rw|' 'Role||||r|Admin' 'Accept_Conditions|checkbox||||'

  Notes:
    - Optional fields will assume a default value if they are not specified.
    - A temporary file is suggested to used with this command: $ mktemp.
    - The outfile must not exist or be an empty file.
```

##### **Purpose**:

Provide a terminal form input with simple validation.

##### **Returns**:

  - **0** on success and form was validated and Accepted.
  - **127** if the user Canceled (**Esc** pressed).
  - **non-zero** for all other cases.

##### **Parameters**: 

  - $1 _Required_     : The output file where the results will be stored.
  - $2..$N _Required_ : The form fields to be displayed for input.

##### **Examples:**

```bash
  $ __hhs_minput /tmp/out.txt \
    'Name|||5/30|rw|' \
    'Age||number|1/3||' \
    'Password|password||5|rw|' \
    'Role||||r|Admin' \
    'Accept_Conditions|checkbox||||' && cat /tmp/out.txt
```


### MSelect Tool

#### __hhs_mselect

```bash
Usage: __hhs_mselect <output_file> <items...>

    Arguments:
      output_file : The output file where the result will be stored.
      items       : The items to be displayed for selecting.

    Examples:
      Selct a number from 1 to 100:
        => __hhs_mselect /tmp/out.txt {1..100} && cat /tmp/out.txt

  Notes:
    - If only one option is available, mselect will select it and return.
    - A temporary file is suggested to used with this command: $ mktemp.
    - The outfile must not exist or it be an empty file.
```

##### **Purpose**:

Select an option from a list using a navigable menu.

##### **Returns**:

  - **0** on success and if the selected item was Accepted.
  - **127** if the user Canceled (**Q** pressed).
  - **non-zero** for all other cases.

##### **Parameters**: 

  - $1 _Required_     : The output file where the result will be stored.
  - $2..$N _Required_ : The items to be displayed for selecting.

##### **Examples:**

```bash
  $ __hhs_mselect /tmp/out.txt {1..100} && echo "One item has been selected" && cat /tmp/out.txt
```


### Network Related

TODO


### Paths Tool

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

Manage your custom PATH entries. To add to your PATH, the directory must be a valid dirctory path.

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

### Profile Related

TODO


### Punch-Tool

### __hhs_punch

```bash
Usage: __hhs_punch [options] <args>

    Options:
      -l        : List all registered punches.
      -e        : Edit current punch file.
      -r        : Reset punches for the current week and save the previous one.
      -w <week> : Report (list) all punches of specified week using the pattern: week-N.punch.

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


### Search Related

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


### Security Related

### __hhs_encrypt_file

```bash
Usage: __hhs_encrypt_file <filename> <passphrase>  [keep]
```

##### **Purpose**:

Encrypt file using GPG.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The file to encrypt.
  - $2 _Required_ : The passphrase used to encrypt the file.
  - $3 _Required_ : If provided, keeps the decrypted file, delete it otherwise.

##### **Examples:**

```bash
  $ __hhs_encrypt_file my-passwords.txt 112233 && echo "my-passwords.txt is now encrypted"
```

------
### __hhs_decrypt_file

```bash
Usage: __hhs_decrypt_file <filename> <passphrase> [keep]
```

##### **Purpose**:

Decrypt a GPG encrypted file.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The file to decrypt.
  - $2 _Required_ : The passphrase used to decrypt the file.
  - $3 _Required_ : If provided, keeps the encrypted file, delete it otherwise.

##### **Examples:**

```bash
  $ __hhs_decrypt_file my-passwords.txt 112233 && echo "my-passwords.txt is now decrypted"
```


### Shell Utilities

### __hhs_history

```bash
Usage: __hhs_history [regex_filter]
```

##### **Purpose**:

Search for previously issued commands from history using filters.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Optional_ : The case-insensitive filter to be used when listing.

##### **Examples:**

```bash
  $ hist ls && echo "List previously type `ls' commands"
```

------
### __hhs_envs

```bash
Usage: __hhs_envs [regex_filter]
```

##### **Purpose**:

Display all environment variables using filters.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Optional_ : The case-insensitive filter to be used when listing.

##### **Examples:**

```bash
  $ envs hhs && echo "That's all HHS variables"
```

------
### __hhs_shell_select

```bash
Usage: __hhs_shell_select
```

##### **Purpose**:

Select a shell from the existing shell list.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: -

##### **Examples:**

```bash
  $ __hhs_shell_select
```


### System Utilities

### __hhs_sysinfo

```bash
Usage: __hhs_sysinfo
```

##### **Purpose**:

Display relevant system information.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: -

##### **Examples:**

```bash
  $ __hhs_sysinfo
```

------
### __hhs_process_list

```bash
Usage: __hhs_process_list [options] <process_name> [kill]

    Options:
        -i : Make case insensitive search
        -w : Match full words only
        -f : Do not ask questions when killing processes
        -q : Be less verbose as possible

  Notes:
    kill : If specified, it will kill the process it finds
```

##### **Purpose**:

Display a process list matching the process name/expression.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 __Required__ : The process name to check.
  - $2 __Optional__ : Whether to kill all found processes.

##### **Examples:**

```bash
  $ __hhs_process_list java && echo "Listed all Java processes"
  $ __hhs_process_list -i JAVA kill && echo "Listed all Java processes and killing them"
```

------
### __hhs_process_kill

```bash
Usage: __hhs_process_kill [options] <process_name>

    Options:
        -f | --force : Do not prompt for confirmation when killing a process
```

##### **Purpose**:

Kills ALL processes specified by name.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 __Required__ : The process name to kill.

##### **Examples:**

```bash
  $ __hhs_process_kill java
```

------
### __hhs_partitions

```bash
Usage: __hhs_partitions
```

##### **Purpose**:

Exhibit a Human readable summary about all partitions.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: -

##### **Examples:**

```bash
  $ __hhs_partitions
```


### Taylor Tool

------
### __hhs_tailor

```bash
Usage: __hhs_tailor [filename]

  Notes:
    filename: If not provided, stdin will be used instead
```

##### **Purpose**:

Tail a log using colors and patterns specified on `.tailor' file

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  $1 _Required_ : The log file name.

##### **Examples:**

```bash
  $ __hhs_tailor /var/log/syslog.log
  $ cat /var/log/syslog.log | __hhs_tailor
```


### Text Tool

TODO


### Toolchecks

TODO








------
### __hhs

```bash
Usage: 
```

##### **Purpose**:

TODO

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

TODO

##### **Examples:**

```bash
  $ example here
```







------
## Development Tools

TODO
