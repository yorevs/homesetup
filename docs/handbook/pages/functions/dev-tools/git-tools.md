# HomeSetup Developer-Tools Functions Handbook

## Table of contents

<!-- toc -->
- [Standard Tools](../../functions.md#standard-tools)
  * [General](../std-tools/general.md)
  * [Aliases Related](../std-tools/aliases-related.md)
  * [Built-ins](../std-tools/built-ins.md)
  * [Command Tool](../std-tools/command-tool.md)
  * [Directory Related](../std-tools/directory-related.md)
  * [File Related](../std-tools/file-related.md)
  * [MChoose Tool](../std-tools/mchoose-tool.md)
  * [MInput Tool](../std-tools/minput-tool.md)
  * [MSelect Tool](../std-tools/mselect-tool.md)
  * [Network Related](../std-tools/network-related.md)
  * [Paths Tool](../std-tools/paths-tool.md)
  * [Profile Related](../std-tools/profile-related.md)
  * [Punch-Tool](../std-tools/punch-tool.md)
  * [Search Related](../std-tools/search-related.md)
  * [Security Related](../std-tools/security-related.md)
  * [Shell Utilities](../std-tools/shell-utilities.md)
  * [System Utilities](../std-tools/system-utilities.md)
  * [Taylor Tool](../std-tools/taylor-tool.md)
  * [Text Utilities](../std-tools/text-utilities.md)
  * [Toolchecks](../std-tools/toolchecks.md)
- [Development Tools](../../functions.md#development-tools)
  * [Gradle](gradle-tools.md)
  * [Docker](docker-tools.md)
  * [Git](git-tools.md)
<!-- tocstop -->


### Git functions

#### __hhs_git_branch_previous

```bash
Usage: __hhs_git_branch_previous 
```

##### **Purpose**:

Checkout the previous branch in history (skips branch-to-same-branch changes ).

##### **Returns**:

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**: -

##### **Examples:**

```bash
  $ __hhs_git_branch_previous
```


-----
#### __hhs_git_branch_select

```bash
Usage: __hhs_git_branch_select [options]

    Options:
      -l | --local : List only local branches. Do not fetch remote branches.
```

##### **Purpose**:

Select and checkout a local or remote branch.

##### **Returns**:

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : Fetch all branches instead of only local branches (default).

##### **Examples:**

```bash
  $ __hhs_git_branch_select -l
```


-----
#### __hhs_git_branch_all

```bash
Usage: __hhs_git_branch_all [base_search_path]
```

##### **Purpose**:

Get the current branch name of all repositories from the base search path.

##### **Returns**:

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Optional_ : The base path to search for git repositories. Default is current directory.

##### **Examples:**

```bash
  $ __hhs_git_branch_all .
```


-----
#### __hhs_git_status_all

```bash
Usage: __hhs_git_status_all [base_search_path]
```

##### **Purpose**:

Get the status of current branch of all repositories from the base search path.

##### **Returns**:

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Optional_ : The base path to search for git repositories. Default is current directory.

##### **Examples:**

```bash
  $ __hhs_git_status_all .
```


-----
#### __hhs_git_show_file_diff

```bash
Usage: __hhs_git_show_file_diff <first_commit_id> <second_commit_id> <filename>
```

##### **Purpose**:

Display a file diff comparing the version between the first and second commit IDs.

##### **Returns**:

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The first commit ID.
  - $2 _Required_ : The second commit ID.
  - $3 _Required_ : The file to be compared.

##### **Examples:**

```bash
  $  __hhs_git_show_file_diff HEAD~5 HEAD .VERSION
```


-----
#### __hhs_git_show_file_contents

```bash
Usage: __hhs_git_show_file_contents <commit_id> <filename>
```

##### **Purpose**:

__hhs_git_show_file_contents

##### **Returns**:

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The commit ID.
  - $2 _Required_ : The filename to show contents from.

##### **Examples:**

```bash
  $ __hhs_git_show_file_contents HEAD~5 .VERSION
```


-----
#### __hhs_git_show_changes

```bash
Usage: __hhs_git_show_changes <commit_id>
```

##### **Purpose**:

List all changed files from a commit ID.

##### **Returns**:

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The commit ID.

##### **Examples:**

```bash
  $ __hhs_git_show_changes HEAD~5
```


-----
#### __hhs_git_pull_all

```bash
Usage: __hhs_git_pull_all [base_search_path] [repository]

    Arguments:
      repos_search_path   : The base path to search for git repositories. Default is current directory.
      repository          : The remote repository to pull from. Default is \"origin\".
```

##### **Purpose**:

Search and pull projects from the specified path using the given repository/branch.

##### **Returns**:

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Optional_ : The base path to search for git repositories.
  - $2 _Optional_ : The remote repository to pull from.

##### **Examples:**

```bash
  $ __hhs_git_pull_all . origin
```
