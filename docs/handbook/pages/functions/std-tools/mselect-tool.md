# HomeSetup Standard-Tools Functions Handbook

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


### MSelect tool

#### __hhs_mselect

```bash
Usage: __hhs_mselect <output_file> <items...>

    Arguments:
      output_file : The output file where the result will be stored.
      items       : The items to be displayed for selecting.

    Examples:
      Select a number from 1 to 100:
        => __hhs_mselect /tmp/out.txt {1..100} && cat /tmp/out.txt

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
  - $2..$N _Required_ : The items to be displayed for selecting.

##### **Examples:**

```bash
  $ __hhs_mselect /tmp/out.txt {1..100} && echo "One item has been selected" && cat /tmp/out.txt
```
