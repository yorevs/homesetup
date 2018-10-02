# HomeSetup
## Terminal .dotfiles and bash improvements for MacOs

### 1. Installation

#### 1.1 Clone the repository using the following command:

`#> git clone https://github.com/yorevs/homesetup.git ~/HomeSetup`

#### 1.2 Install dotfiles:

`#> cd ~/HomeSetup && ./install.sh` => **To install one by one**
or
`#> cd ~/HomeSetup && ./install.sh -a` => **To install all files**

Your old dotfiles will be backed up using .bak suffix.

### 2. Dotfiles in this project

The following files will be added when installing this project:

```
~/.bashrc # Bash resources init
~/.bash_profile # Profile bash init
~/.bash_aliases # All defined aliases
~/.bash_prompt # Enhanced shell prompt
~/.bash_env # Environment variables
~/.bash_colors # All defined color related stuff
~/.bash_functions # Scripting functions
```

The following directory will be linked to your HOME folder:

`~/bin # Includes all useful script provided by the project`

If this folder already exists, the install script will copy all files into it.

To override or add customised aliases, profile stuff and environment variables, you need to create a custom file as follows:

```
~/.aliases # For aliases customisation
~/.profile # For profile customisation
~/.env # For environment variables customisation
```

### 3. Aliases

This project will many aliases (shortcuts) to your shell:

#### Navigational

ALIAS   | Equivalent
------- | ----------
..      | cd ..
...     | cd ...
....    | cd ....
.....   | cd .....
~       | cd ~
-       | cd -
?       | pwd

#### General

ALIAS   | Equivalent
------- | -------
q       | exit
reload  | 'Reload all dotfiles and check for updates'
save    | 'Save the current directory to be loaded by `load` alias'
load    | 'cd into the saved directory issued by `save` alias'
sudo    | 'Enable aliases to be sudo’ed'
cls     | clear
vi      | vim
tl      | tail -F
week    | 'Current week of the month' 
now     | 'Current date'
now-ms  | 'Current timestamp in milliseconds'

**Please check: [bash_aliases](./bash_aliases.sh) for all aliases**

### 4. Functions

This project adds many script functions the shell.

**Please check: [bash_functions](./bash_functions.sh) for all functions**

### 5. Scripts

The project contains some useful scripts that can be used directly from shell. It is also added to your path variable.

**Please check: [bin](./bin) for all scripts**


