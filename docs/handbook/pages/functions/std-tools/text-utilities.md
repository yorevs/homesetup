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
  * [MChoose Tool](clitt.md#mchoose-tool)
  * [MInput Tool](clitt.md#minput-tool)
  * [MSelect Tool](clitt.md#mselect-tool)
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


### Text utilities

### __hhs_errcho

```bash
Usage: __hhs_errcho <message>
```

##### **Purpose**:

Echo a message in red color into stderr.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The message to be echoed.

##### **Examples:**

```bash
  $ __hhs_errcho "Invalid parameters"
```

------
### __hhs_highlight

```bash
Usage: __hhs_highlight <text_to_highlight> [filename]

  Notes:
    filename: If not provided, stdin will be used instead
```

##### **Purpose**:

Highlight words from the piped stream.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The word to highlight.
  - $2 _Piped_ : The piped input stream.

##### **Examples:**

```bash
  $ __hhs_highlight "apple" /var/log/system.log
  $ cat /var/log/system.log | __hhs_highlight "apple"
```

------
### __hhs_json_print

```bash
Usage: __hhs_json_print <json_string>
```

##### **Purpose**:

Pretty print (format) JSON string.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The unformatted JSON string.

##### **Examples:**

```bash
  $ __hhs_json_print '[{"name":"my name","age":30}]'
```
