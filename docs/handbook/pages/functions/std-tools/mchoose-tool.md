# HomeSetup MChoose Tool Handbook

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


### MChoose tool

#### __hhs_mchoose

```bash
Usage: __hhs_mchoose [options] <output_file> <items...>

    Options:
      -c  : All options are initially checked instead of unchecked.

    Arguments:
      output_file : The output file where the results will be stored.
      items       : The items to be displayed for choosing.

    Examples:
      Choose numbers from 1 to 20 (start with all options checked):
        => __hhs_mchoose /tmp/out.txt {1..20} && cat /tmp/out.txt
      Choose numbers from 1 to 20 (start with all options unchecked):
        => __hhs_mchoose -c /tmp/out.txt {1..20} && cat /tmp/out.txt

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
  - $2..$N _Required_ : The items to be displayed for choosing.

##### **Examples:**

```bash
  $ __hhs_mchoose /tmp/out.txt {1..20} && echo "All options initially unchecked" && cat /tmp/out.txt
  $ __hhs_mchoose -c /tmp/out.txt {1..20} && echo "All options initially checked" && cat /tmp/out.txt
```
