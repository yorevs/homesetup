# HomeSetup Text Utilities Functions Handbook

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
  * [Toolchecks](toolchecks.md)
- [Development Tools](../../functions.md#development-tools)
  * [Gradle](../dev-tools/gradle-tools.md)
  * [Docker](../dev-tools/docker-tools.md)
  * [Git](../dev-tools/git-tools.md)
<!-- tocstop -->


### Text utilities functions

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

------
### __hhs_edit

```bash
Usage: __hhs_edit <file_path>
```

##### **Purpose**:

Create and/or open a file using the default editor.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The file path.

##### **Examples:**

```bash
  $ example here
```
