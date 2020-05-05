# HomeSetup Security Related Functions Handbook

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


### Security related functions

### __hhs_encrypt_file

```bash
Usage: __hhs_encrypt_file <filename> <passphrase>  [keep]
```

##### **Purpose**:

Encrypt file using GPG.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The file to encrypt.
  - $2 _Required_ : The passphrase used to encrypt the file.
  - $3 _Required_ : If provided, keeps the decrypted file, delete it otherwise.

##### **Examples:**

```bash
  $ __hhs_encrypt_file my-passwords.txt 112233 && echo "my-passwords.txt is now encrypted"
```

------
### __hhs_decrypt_file

```bash
Usage: __hhs_decrypt_file <filename> <passphrase> [keep]
```

##### **Purpose**:

Decrypt a GPG encrypted file.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The file to decrypt.
  - $2 _Required_ : The passphrase used to decrypt the file.
  - $3 _Required_ : If provided, keeps the encrypted file, delete it otherwise.

##### **Examples:**

```bash
  $ __hhs_decrypt_file my-passwords.txt 112233 && echo "my-passwords.txt is now decrypted"
```
