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

### Search related functions

### __hhs_search_file

```bash
Usage: __hhs_search_file <search_path> [file_globs...]

  Notes:
    ** <globs...>: Comma separated globs. E.g: "*.txt,*.md,*.rtf"
```

##### **Purpose**

Search for files and links to files recursively.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_     : The base search path.
  - $2 _Required_     : The search glob expressions.

##### **Examples**

`__hhs_search_file . '*.properties,*.yaml'`

**Output**

```bash
./tests/bats/bats-core/.pre-commit-config.yaml
./gradle/wrapper/gradle-wrapper.properties
./.gradle/7.4/gc.properties
./.gradle/7.4/dependencies-accessors/gc.properties
./.gradle/vcs-1/gc.properties
./.gradle/buildOutputCleanup/cache.properties
./.gradle/7.4.2/gc.properties
./.gradle/7.4.2/dependencies-accessors/gc.properties
./gradle.properties
./assets/colorls/hhs-preset/file_aliases.yaml
./assets/colorls/hhs-preset/dark_colors.yaml
./assets/colorls/hhs-preset/folder_aliases.yaml
./assets/colorls/hhs-preset/folders.yaml
./assets/colorls/hhs-preset/light_colors.yaml
./assets/colorls/hhs-preset/files.yaml
./assets/colorls/orig-preset/file_aliases.yaml
./assets/colorls/orig-preset/dark_colors.yaml
./assets/colorls/orig-preset/folder_aliases.yaml
./assets/colorls/orig-preset/folders.yaml
./assets/colorls/orig-preset/light_colors.yaml
./assets/colorls/orig-preset/files.yaml
```

------

### __hhs_search_dir

```bash
Usage: __hhs_search_dir <search_path> [dir_globs...]

  Notes:
  ** <dir_names...>: Comma separated directories. E.g:. "dir1,dir2,dir2"
```

##### **Purpose**

Search for directories and links to directories recursively.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_     : The base search path.
  - $2 _Required_     : The search glob expressions.

##### **Examples**

`__hhs_search_dir . 'bash*,bin*'`

**Output**

```bash
./dotfiles/bash
./bin
./bin/hhs-functions/bash
./bin/completions/bash
./bin/key-bindings/bash
./bin/dev-tools/bash
./bin/apps/bash
./tests/bats/bats-core/bin
./docs/handbook/pages/applications/bash
./templates/bash
```

------

### __hhs_search_string

```bash
Usage: __hhs_search_string <search_path> [options] <regex/string> [file_globs]

    Options:
      -i | --ignore-case            : Makes the search case INSENSITIVE.
      -w | --words                  : Makes the search to use the STRING words instead of a REGEX.
      -r | --replace <replacement>  : Makes the search to REPLACE all occurrences by the replacement string.
      -b | --binary                 : Includes BINARY files in the search.

  Notes:
    - <file_globs...>: Comma separated file globs. E.g: "*.txt,*.md,*.rtf"
```

##### **Purpose**

Search in files for strings matching the specified criteria recursively.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_     : The base search path.
  - $2 _Required_     : The search expression. Can be a regex or just a string.
  - $3 _Required_     : The search glob expressions.

##### **Examples**

```bash
  $ __hhs_search_string /var/log 'apple' '*.log'
  $ __hhs_search_string . 'server.port' '*.properties,*.yaml'
  $ __hhs_search_string -r 'server.port = 1234' . 'server.port *= *.*' '*.properties,*.yaml'
```
