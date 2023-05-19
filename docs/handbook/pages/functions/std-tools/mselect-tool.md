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
