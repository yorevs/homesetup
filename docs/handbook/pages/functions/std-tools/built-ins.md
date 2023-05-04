# HomeSetup Standard-Tools Functions Handbook

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


### Built-ins functions

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

------
### __hhs_open

```bash
Usage: __hhs_open <file_path>
```

##### **Purpose**:

Open a file or URL with the default program.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The url or program arguments to be passed to open.

##### **Examples:**

```bash
  $ __hhs_open http://google.com
  $ __hhs_open /tmp/test.txt
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
  $ __hhs_edit /tmp/test.txt
```
