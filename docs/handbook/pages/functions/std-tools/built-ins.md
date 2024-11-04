<img src="https://iili.io/HvtxC1S.png" width="64" height="64" align="right" />

# HomeSetup Developer Handbook
>
> Standard-Tools

__hhs_help......................... : Display a help for the given command.
__hhs_where_am_i................... : Display the current working dir and remote repository if it ap...
__hhs_shopt........................ : Display/Set/unset current Shell Options.
__hhs_random....................... : Generate a random number int the range <min> <max> (all limits...
__hhs_open......................... : Open a file or URL with the default program.
__hhs_edit......................... : Create and/or open a file using the default editor.
__hhs_about........................ : Display information about the given command.

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

### Built-ins functions

#### __hhs_random

```bash
usage: __hhs_random <min> <max>
```

##### **Purpose**

Generate a random number int the range <min> <max> (all limits included).

##### **Returns**

**0** if the number was generated; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_ : The minimum range of the number.
  - $2 _Required_ : The maximum range of the number.

##### **Examples**

`__hhs_random 0 10`

**Output**

```bash
1
```

------

### __hhs_open

```bash
usage: __hhs_open <file_path>
```

##### **Purpose**

Open a file or URL with the default program.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_ : The url or program arguments to be passed to open.

##### **Examples**

`__hhs_open http://google.com`

**Output**

N/A

`__hhs_open /tmp/test.txt`

**Output**

N/A

------

### __hhs_edit

```bash
usage: __hhs_edit <file_path>
```

##### **Purpose**

Create and/or open a file using the default editor.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_ : The file path.

##### **Examples**

`__hhs_edit /tmp/test.txt`

**Output**

N/A

------

### __hhs_about

```bash
usage: __hhs_about <command>
```

##### **Purpose**

Display information about the given command.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_ : The command name.

##### **Examples**

`__hhs_about ls`

**Output**

```bash
    Aliased: ls => colorls --dark --group-directories-first --git-status
    Command: ls => /bin/ls
```

------

### __hhs_help

```bash
usage: __hhs_help <command>
```

##### **Purpose**

Display a help for the given command.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_ : The command to get help.

##### **Examples**

`__hhs_help starship`

**Output**

```bash
The cross-shell prompt for astronauts. ☄🌌️

usage: starship <COMMAND>

Commands:
  bug-report    Create a pre-populated GitHub issue with information about your configuration
  completions   Generate starship shell completions for your shell to stdout
  config        Edit the starship configuration
  explain       Explains the currently showing modules
  init          Prints the shell function used to execute starship
  module        Prints a specific prompt module
  preset        Prints a preset config
  print-config  Prints the computed starship configuration
  prompt        Prints the full starship prompt
  session       Generate random session key
  timings       Prints timings of all active modules
  toggle        Toggle a given starship module
  help          Print this message or the help of the given subcommand(s)

Options:
  -h, --help     Print help
  -V, --version  Print version
```

------

### __hhs_where_am_i

```bash
usage: __hhs_where_am_i
```

##### **Purpose**

Display the current dir (pwd) and remote repo url, if it applies.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

N/A

##### **Examples**

`__hhs_where_am_i`

N/A

------

### __hhs_shopt

```bash
usage: __hhs_shopt [on|off] | [-pqsu] [-o] [optname ...]

    Options:
      off : Display all unset options.
      on  : Display all set options.
      -s  : Enable (set) each optname.
      -u  : Disable (unset) each optname.
      -p  : Display a list of all settable options, with an indication of whether or not each is set.
            The output is displayed in a form that can be reused as input. (-p is the default action).
      -q  : Suppresses normal output; the return status indicates whether the optname is set or unset.
            If multiple optname arguments are given with '-q', the return status is zero if all optnames
            are enabled; non-zero otherwise.
      -o  : Restricts the values of optname to be those defined for the '-o' option to the set builtin.

  Notes:
    If no option is provided, then, display all set & unset options.
```

##### **Purpose**

Display/Set/unset current Shell Options.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Optional_ : Display all set/unset options.
  - $2 _Optional_ : Enable/Disable (set/unset) each optname.
  - $3 _Optional_ : Display a list of all settable options.
  - $4 _Optional_ : Suppresses normal output; quiet mode.
  - $5 _Optional_ : Restricts the values of optname to be those defined for the '-o' option to the set builtin.

##### **Examples**

`__hhs_shopt`

**Output**

```bash
Available shell on and off options (34):

     OFF	cdable_vars
     OFF	cdspell
     OFF	checkhash
     ON	checkwinsize
     ON	cmdhist
     OFF	compat31
...
...
```

`__hhs_shopt on`

**Output**

```bash
Available shell on options (34):

     ON	checkwinsize
     ON	cmdhist
     ON	expand_aliases
     ON	extquote
     ON	force_fignore
     ON	hostcomplete
     ON	interactive_comments
     ON	login_shell
     ON	progcomp
     ON	promptvars
     ON	sourcepath
```
