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


### Security related functions

#### __hhs_encrypt_file

```bash
Usage: __hhs_encrypt_file <filename> <passphrase>  [keep]
```

##### **Purpose**

Encrypt file using GPG.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_ : The file to encrypt.
  - $2 _Required_ : The passphrase used to encrypt the file.
  - $3 _Required_ : If provided, keeps the decrypted file, delete it otherwise.

##### **Examples**

`encrypt test.txt '12345'`

**Output**

```bash
File "test.txt" has been encrypted !
```

------

#### __hhs_decrypt_file

```bash
Usage: __hhs_decrypt_file <filename> <passphrase> [keep]
```

##### **Purpose**

Decrypt a GPG encrypted file.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_ : The file to decrypt.
  - $2 _Required_ : The passphrase used to decrypt the file.
  - $3 _Required_ : If provided, keeps the encrypted file, delete it otherwise.

##### **Examples**

`decrypt test.txt '12345'`

**Output**

```bash
File "test.txt" has been decrypted !
```
