# HomeSetup Built-ins Functions Handbook

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
