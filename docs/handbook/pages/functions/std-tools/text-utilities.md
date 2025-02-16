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

### Text utilities

#### __hhs_highlight

```bash
usage: __hhs_highlight <text_to_highlight> [filename]

  Notes:
    filename: If not provided, stdin will be used instead.
```

##### **Purpose**

Highlight words from the piped stream.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_ : The word to highlight.
  - $2 _Piped_ : The piped input stream.

##### **Examples**

`__hhs_highlight MIT LICENSE.md`

**Output**

```bash
The MIT License (MIT)
in the Software without restriction, including without limitation the rights
copies of the Software, and to permit persons to whom the Software is
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
```

------

#### __hhs_json_print

```bash
usage: __hhs_json_print <json_string>
```

##### **Purpose**

Pretty print (format) JSON string.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_ : The unformatted JSON string.

##### **Examples**

`__hhs_json_print '[{"name":"my name","age":30}]'`

**Output**

```bash
[
  {
    "name": "my name",
    "age": 30
  }
]
```

------

##### __hhs_ascof

```bash
usage: __hhs_ascof <string>
```

##### **Purpose**

Convert string into it's decimal ASCII representation.

##### **Returns**

**0** if the representation was displayed; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_ : The string to convert.

##### **Examples**

`__hhs_ascof Hello`

**Output**

```bash
Dec: 72 101 108 108 111
Hex: 48  65  6c  6c  6f
Str: Hello
```

------

##### __hhs_utoh

```bash
usage: __hhs_utoh <4d-unicode...>

  Notes:
    - unicode is a four digits hexadecimal number. E.g:. F205
    - exceeding digits will be ignored
```

##### **Purpose**

Convert unicode to hexadecimal.

##### **Returns**

**0** if the unicode was successfully converted; **non-zero** otherwise.

##### **Parameters**

  - $1..$N _Required_ : The unicode values to convert.

##### **Examples**

`__hhs_utoh f123 f133`

**Output**

```bash
[Unicode:'\uf123']
  Hex => \xef\x84\xa3
  Icn => 
  Oct => \357\204\243

[Unicode:'\uf133']
  Hex => \xef\x84\xb3
  Icn => 
  Oct => \357\204\263
```

------

#### __hhs_errcho

```bash
usage: __hhs_errcho <message>
```

##### **Purpose**

Echo a message in red color into stderr.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_ : The message to be echoed.

##### **Examples**

`__hhs_errcho 'Invalid parameters'`

**Output**

```bash
error: Invalid parameters
```

