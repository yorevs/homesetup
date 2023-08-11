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


### MChoose tool

#### __hhs_mchoose

```bash
Usage: __hhs_mchoose [options] <output_file> <title> <items...>

    Options: 
      -c  : All options are initially checked instead of unchecked.

    Arguments: 
      output_file : The output file where the results will be stored.
      title       : The text to be displayed before rendering the items.
      items       : The items to be displayed for choosing. Must be greater than 1.

    Examples: 
      Choose numbers from 1 to 20 (start with all options checked):
        => __hhs_mchoose /tmp/out.txt 'Mark the desired options' {1..20} && cat /tmp/out.txt
      Choose numbers from 1 to 20 (start with all options unchecked):
        => __hhs_mchoose -c /tmp/out.txt 'Mark the desired options' {1..20} && cat /tmp/out.txt

  Notes: 
    - A temporary file is suggested to used with this command: $ mktemp.
    - The outfile must not exist or it be an empty file.
```

##### **Purpose**:

Choose options from a list using a navigable menu.

##### **Returns**:

  - **0** on success and if chosen items were Accepted.
  - **127** if the user Canceled (**Q** pressed).
  - **non-zero** for all other cases.

##### **Parameters**: 

  - $1 _Required_     : The output file where the results will be stored.
  - $2 _Required_     : The text to be displayed before rendering the items.
  - $3..$N _Required_ : The items to be displayed for choosing.

##### **Examples:**

```bash
  $ __hhs_mchoose /tmp/out.txt \
    'Mark the desired options' {1..20} \
    && echo -n "These options were checked: " && cat /tmp/out.txt
  $ __hhs_mchoose -c /tmp/out.txt \
    'Unmark the undesired options' {1..20} \
    && echo -n "These options were checked: " && cat /tmp/out.txt
```

------
### MSelect tool

#### __hhs_mselect

```bash
Usage: __hhs_mselect <output_file> <title> <items...>

    Arguments: 
      output_file : The output file where the result will be stored.
      title       : The text to be displayed before rendering the items.
      items       : The items to be displayed for selecting.

    Examples: 
      Select a number from 1 to 100:
        => __hhs_mselect /tmp/out.txt 'Please select one option' {1..100} && cat /tmp/out.txt

  Notes: 
    - If only one option is available, mselect will select it and return.
    - A temporary file is suggested to used with this command: $ mktemp.
    - The outfile must not exist or it be an empty file.
```

##### **Purpose**:

Select an option from a list using a navigable menu.

##### **Returns**:

  - **0** on success and if the selected item was Accepted.
  - **127** if the user Canceled (**Q** pressed).
  - **non-zero** for all other cases.

##### **Parameters**: 

  - $1 _Required_     : The output file where the result will be stored.
  - $2 _Required_     : The text to be displayed before rendering the items.
  - $3..$N _Required_ : The items to be displayed for selecting.

##### **Examples:**

```bash
  $ __hhs_mselect \
    /tmp/out.txt 'Please select one option' {1..100} \
    && echo -n "This item has been selected => " && cat /tmp/out.txt
```

------
### MInput tool

#### __hhs_minput

```bash
Usage: __hhs_minput <output_file> <title> <form_fields...>

    Arguments: 
      output_file : The output file where the results will be stored.
      title       : The text to be displayed before rendering the items.
           fields : A list of form fields: Label|Mode|Type|Min/Max len|Perm|Value

    Fields: 
      Field tokens (in-order):
                    <Label> : The field label. Consisting only of alphanumeric characters and under‐scores.
                     [Mode] : The input mode. One of {[text]|password|checkbox|select|masked}.
                     [Type] : The input type. One of {letters|numbers|words|masked|[anything]}.
              [Min/Max len] : The minimum and maximum length of characters allowed. Defaults to [0/30].
                     [Perm] : The field permissions. One of {r|[rw]}. Where \"r\" for Read Only ; \"rw\" for Read & Write.

    Examples: 
      Form with 4 fields (Name,Age,Password,Role,Accept Conditions): 
        => __hhs_minput /tmp/out.txt 'Please fill the form below:' 'Name|||5/30|rw|' 'Age||numbers|1/3||' 'Password|password||5|rw|' 'Role||||r|Admin' 'Accept Conditions|checkbox||||' 

  Notes: 
    - Optional fields will assume a default value if they are not specified.
    - A temporary file is suggested to used with this command: $ mktemp.
```

##### **Purpose**:

Provide a terminal form input with simple validation.

##### **Returns**:

  - **0** on success and form was validated and Accepted.
  - **127** if the user Canceled (**Esc** pressed).
  - **non-zero** for all other cases.

##### **Parameters**: 

  - $1 _Required_     : The output file where the results will be stored.
  - $2 _Required_     : The text to be displayed before rendering the items.
  - $3..$N _Required_ : The form fields to be displayed for input.

##### **Examples:**

```bash
  $ __hhs_minput /tmp/out.txt 'Please fill the form below:' \
    'Name|||5/30|rw|' \
    'Age|masked|masked|1/3|| ;###' \
    'Password|password||5|rw|' \
    'Role|select||4/5|rw|Admin;<User>;Guest' \
    'Locked||||r|locked value' \
    'Accept Conditions|checkbox||||' && cat /tmp/out.txt
```