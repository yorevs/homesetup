<img src="https://iili.io/HvtxC1S.png" width="64" height="64" align="right" />

# HomeSetup Developer Handbook
>
> Developer-Tools

## Table of contents

<!-- toc -->

- [Standard Tools](../../functions.md#standard-tools)
  - [General](../std-tools/general.md#general-functions)
  - [Aliases Related](../std-tools/aliases-related.md#aliases-related-functions)
  - [Built-ins](../std-tools/built-ins.md#built-ins-functions)
  - [Command Tool](../std-tools/command-tool.md#command-tool)
  - [Directory Related](../std-tools/directory-related.md#directory-related-functions)
  - [File Related](../std-tools/file-related.md#file-related-functions)
  - [MChoose Tool](../std-tools/clitt.md#mchoose-tool)
  - [MInput Tool](../std-tools/clitt.md#minput-tool)
  - [MSelect Tool](../std-tools/clitt.md#mselect-tool)
  - [Network Related](../std-tools/network-related.md#network-related-functions)
  - [Paths Tool](../std-tools/paths-tool.md#paths-tool)
  - [Profile Related](../std-tools/profile-related.md#profile-related-functions)
  - [Punch-Tool](../std-tools/punch-tool.md#punch-tool)
  - [Search Related](../std-tools/search-related.md#search-related-functions)
  - [Security Related](../std-tools/security-related.md#security-related-functions)
  - [Shell Utilities](../std-tools/shell-utilities.md#shell-utilities)
  - [System Utilities](../std-tools/system-utilities.md#system-utilities)
  - [Taylor Tool](../std-tools/taylor-tool.md#taylor-tool)
  - [Text Utilities](../std-tools/text-utilities.md#text-utilities)
  - [Toolchecks](../std-tools/toolchecks.md#tool-checks-functions)
- [Development Tools](../../functions.md#development-tools)
  - [Gradle](gradle-tools.md#gradle-functions)
  - [Docker](docker-tools.md#docker-functions)
  - [Git](git-tools.md#git-functions)
-
<!-- tocstop -->

### Git functions

#### __hhs_git_branch_previous

```bash
Usage: __hhs_git_branch_previous
```

##### **Purpose**

Checkout the previous branch in history (skips branch-to-same-branch changes ).

##### **Returns**

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**

##### **Examples**

`__hhs_git_branch_previous`

**Output**

```bash
Switched to branch 'prev-branch'
```

-----

#### __hhs_git_branch_select

```bash
Usage: __hhs_git_branch_select [options]

    Options:
      -l | --local : List only local branches. Do not fetch remote branches.
```

##### **Purpose**

Select and checkout a local or remote branch.

##### **Returns**

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**

- $1 _Optional_ : Fetch all branches instead of only local branches (default).

##### **Examples**

`__hhs_git_branch_select`

**Output**

```bash
Select a local or remote branch to checkout

  1    master
  2     v1-7-1
  3     remotes/origin/develop
  4     remotes/origin/master
  5     remotes/origin/v1-7-1

[Enter] Select  [↑↓] Navigate  [Esc] Quit  [1..5] Goto:
```

-----

#### __hhs_git_branch_all

```bash
Usage: __hhs_git_branch_all [base_search_path]
```

##### **Purpose**

Get the current branch name of all repositories from the base search path.

##### **Returns**

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**

- $1 _Optional_ : The base path to search for git repositories. Default is current directory.

##### **Examples**

`__hhs_git_branch_all .`

**Output**

```bash
Choose the projects to pull from. Available Repositories (2):

  1      ~/.nvm/.git
  2       ~/HomeSetup/.git

[Enter] Accept  [↑↓] Navigate  [Space] Mark  [I] Invert  [Esc] Quit  [1..2] Goto:
```

-----

#### __hhs_git_status_all

```bash
Usage: __hhs_git_status_all [base_search_path]
```

##### **Purpose**

Get the status of current branch of all repositories from the base search path.

##### **Returns**

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**

- $1 _Optional_ : The base path to search for git repositories. Default is current directory.

##### **Examples**

`__hhs_git_status_all .`

**Output**

```bash
Fetching status of .nvm ...

On branch main

No commits yet

nothing added to commit but untracked files present (use "git add" to track)

Fetching status of HomeSetup ...

On branch master
Your branch is up to date with 'origin/master'.

no changes added to commit (use "git add" and/or "git commit -a")
```

-----

#### __hhs_git_show_file_diff

```bash
Usage: __hhs_git_show_file_diff <first_commit_id> <second_commit_id> <filename>
```

##### **Purpose**

Display a file diff comparing the version between the first and second commit IDs.

##### **Returns**

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**

- $1 _Required_ : The first commit ID.
- $2 _Required_ : The second commit ID.
- $3 _Required_ : The file to be compared.

##### **Examples**

`__hhs_git_show_file_diff HEAD~135 HEAD .VERSION`

**Output**

```bash
diff --git a/.VERSION b/.VERSION
old mode 100755
new mode 100644
index 84af258..8106157
--- a/.VERSION
+++ b/.VERSION
@@ -1 +1 @@
-1.6.18
\ No newline at end of file
+1.6.19
\ No newline at end of file
```

-----

#### __hhs_git_show_file_contents

```bash
Usage: __hhs_git_show_file_contents <commit_id> <filename>
```

##### **Purpose**

__hhs_git_show_file_contents

##### **Returns**

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**

- $1 _Required_ : The commit ID.
- $2 _Required_ : The filename to show contents from.

##### **Examples**

`__hhs_git_show_file_contents HEAD~135 .VERSION`

**Output**

```bash
1.6.18
```

-----

#### __hhs_git_show_changes

```bash
Usage: __hhs_git_show_changes <commit_id>
```

##### **Purpose**

List all changed files from a commit ID.

##### **Returns**

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**

- $1 _Required_ : The commit ID.

##### **Examples**

`__hhs_git_show_changes HEAD~135`

**Output**

```bash
bin/apps/bash/hhs-app/plugins/hspm/hspm.bash
dotfiles/bash/bash_aliases.bash
```

-----

#### __hhs_git_pull_all

```bash
Usage: __hhs_git_pull_all [base_search_path] [repository]

    Arguments:
      repos_search_path   : The base path to search for git repositories. Default is current directory.
      repository          : The remote repository to pull from. Default is \"origin\".
```

##### **Purpose**

Search and pull projects from the specified path using the given repository/branch.

##### **Returns**

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**

- $1 _Optional_ : The base path to search for git repositories.
- $2 _Optional_ : The remote repository to pull from.

##### **Examples**

`__hhs_git_pull_all . origin`

```bash
Choose the projects to pull from. Available Repositories (2):

  1      ./.nvm/.git
  2       ./HomeSetup/.git

[Enter] Accept  [↑↓] Navigate  [Space] Mark  [I] Invert  [Esc] Quit  [1..2] Goto:
```
