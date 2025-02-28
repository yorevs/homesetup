# Bash dotfiles

## Bash/Zsh load order

_Executes A, then B, then C, etc._
_B1, B2, B3 means it executes only the first of those files found_

| File             | Interactive login | Interactive non-login | Script |
|------------------|-------------------|-----------------------|--------|
| /etc/profile     | A                 |                       |        |
| /etc/bash.bashrc |                   | A                     |        |
| ~/.bashrc        |                   | B                     |        |
| ~/.bash_profile  | B1                |                       |        |
| ~/.bash_login    | B2                |                       |        |
| ~/.profile       | B3                |                       |        |
| BASH_ENV         |                   |                       | A      |
| ~/.bash_logout   | C                 |                       |        |

## Login Shell

When you login into the computer or change user (su <user>)

`/etc/profile` → `~/.bash_profile` → `~/.profile` → `~/.bash_login`


## Non-Login Shell

`/etc/bash.bashrc` → `~/.bashrc`

## References:

    * https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/
