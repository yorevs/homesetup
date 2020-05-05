# HomeSetup MInput Tool Handbook

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


### MInput tool

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
