# HomeSetup
## Terminal .dotfiles and bash improvements for MacOS

### 1. Installation

#### 1.1 Local installation

Clone the repository using the following command:

`#> git clone https://github.com/yorevs/homesetup.git ~/HomeSetup`

And then install dotfiles using the following command:

`#> cd ~/HomeSetup && ./install.sh` => **To install one by one**

or

`#> cd ~/HomeSetup && ./install.sh -a` => **To install all files**

Your old dotfiles (.bash*) will be backed up using '.orig' suffix and sent to ~/.hhs folder.

#### 1.2 Remote installation ( Directly from GitHub )

Use the following command to clone and install the HomeSetup.

`#> curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.sh | bash`

or

`#> wget -qO- https://raw.githubusercontent.com/yorevs/homesetup/master/install.sh | bash`

#### 1.3 Setup a Firebase account for custom files synchronization

HomeSetup allows you to use your Firebase account to upload and download your custom files
to your *Realtime Database*. To be able to use this feature, you need first to configure
your Firebase account with HomeSetup.

##### 1.3.1 Create a Firebase accout using your Google credentials (If you do not have one)

Access: https://console.firebase.google.com/

1. Create a *new Project* (HomeSetup).
2. Create Database (as **testing mode**).
    * Click on Develop -> Database -> Create Database
    * Click on **Realtime Database**
    * Click on the **Rules** tab.
        - Change the line from: `".read": false,` to `".read": true,`.
        - Change the line from: `".write": false,` to `".write": true,`.
        - Click on the *Publish* button and accept changes.
3. Grab you *Project ID* from the settings Settings menu.

Type in a shell: `#> dotfiles.sh fb setup`

Fill in the information required.
You are now ready to use the Firebase features of HomeSetup.
Type: `#> dotfiles.sh help fb` for further information about using it.

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

To override or add customised stuff, you need to create a custom file as follows:

```
~/.aliases # For aliases customisation
~/.profile # For profile customisation
~/.env # For environment variables customisation
~/.colors # For bash color customisation
~/.functions # For functions customisation
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
\-       | cd -
?       | pwd

#### General

ALIAS    | Equivalent
-------- | --------
q        | exit
reload   | 'Reload all dotfiles and check for updates'
pk       | 'Kills all processes specified by a name'
sudo     | 'Enable aliases to be sudo’ed'
ls       | 'Always use color output for `ls`'
l        | 'List all files colorized in long format'
ll       | 'List all files colorized in long format, including dot files'
lll      | 'List all dotfiles and dotfolders'
lld      | 'List all dotfolders'
lt       | 'List all directories recursively (Nth level depth) as a tree'
grep     | 'Always enable colored `grep` output'
egrep    | 'Always enable colored `egrep` output'
fgrep    | 'Always enable colored `fgrep` output'
rm       | rm -i 'For safety, by default this command will input for confirmation'
cp       | cp -i 'For safety, by default this command will input for confirmation'
mv       | mv -i 'For safety, by default this command will input for confirmation'
cls      | clear
vi       | vim
tl       | tail -F
mount    | 'Make mount command output pretty and human readable format'
mkcd     | Make a folder and cd into it
cpu      | `top` shortcut ordered by cpu
mem      | `top` shortcut ordered by memory
rmdbc    | 'Recursively delete Dropbox conflicted files from the current directory'
week     | 'Current week of the month' 
now      | 'Current date'
now-ms   | 'Current timestamp in milliseconds'
wget     | 'MacOS has no wget, so use curl instead'
rand     | 'Generate a random number from `<min>` to  `<max>`'

#### Python aliases
ALIAS   | Equivalent
------- | -------
calc    | 'Evaluate mathematical expression'
urle    | 'URL-encode string'
urld    | 'URL-decode string'

#### IP related

ALIAS   | Equivalent
------- | -------
ifa     | 'List all active interfaces on the system'
ip      | 'Get the real IP on the internet'
ipl     | 'Get the local IPs on the local network'
ips     | 'Get all associated local IPs of the machine'

#### Mac Stuff

ALIAS      | Equivalent
---------- | ----------
clean-ds   | 'Delete all .DS_store files'
show-files | 'Show hidden files in Finder'
hide-files | 'Hiden hidden files in Finder'

**Please check: [bash_aliases](./bash_aliases.sh) for all aliases**

### 4. Functions

This project adds many script functions the shell. All functions provide a help using the options -h or --help.

Function    | Purpose
----------- | -----------
encrypt     | Encrypt file using GPG encryption.
decrypt     | Decrypt file using GPG encryption.
hl          | Highlight words from the piped stream.
sf          | Search for files recursively.
sd          | Search for directories recursively.
ss          | Search for strings in files recursively.
hist        | Search for a previous issued command from history.
del-tree    | Send files recursively to Trash (del tree).
jp          | Pretty print (format) JSON string.
ip-info     | Check information about the IP.
ip-resolve  | Resolve domain names associated with the IP.
ip-lookup   | Lookup DNS entries to determine the IP address.
port-check  | Check the state of a local port.
envs        | Prints all environment variables.
paths       | Print each PATH entry on a separate line.
ver         | Check the version of the app using common ways.
tc          | Check whether the `tool` is installed.
tools       | Check whether some `dev. tools` are installed.
mselect     | Select an option from a list, using a navigable menu.
aa          | Manipulate all custom aliases `(add/remove/set)`.
save        | Save the one directory to be loaded by `load`.
load        | Pushd into a saved directory issued by `save`.
punch       | Punch the clock. Add, edit and list punches.
plist       | Display (maybe kill?) a process list, given process name.
cmd         | Add/Remove/List/Execute `saved bash commands`.
godir       | Pushd into the first match of the specified directory name.
git-        | GIT Checkout the branch in history (skips branch-to-same-branch ).
sysinfo     | Retrieve some important system information.
parts       | Exhibit a summary about all partitions.
dv          | Check the latest HomeSetup version.

**Please check: [bash_functions](./bash_functions.sh) for all functions**

### 5. Scripts

The project contains some useful scripts that can be used directly from shell. It is also added to your path variable.

#### 5.1 Python scripts

Function                | Purpose
----------------------- | -----------------------
build-java-hierarchy.py | Build a hierarchy spread sheet from a Java project
calc.py                 | Simple app to do mathematical calculations
tcalc.py                | Simple app to do mathematical calculations with time
free.py                 | Report system memory usage
send-msg.py             | IP Message Sender. Sends UDP/TCP messages using multi-threads

#### 5.2 Shell scripts

Function                | Purpose
----------------------- | -----------------------
dotfiles.sh             | Manage your HomeSetup dotfiles and more
fetch.sh                | Script to fetch REST APIs data
git-completion.sh       | bash/zsh completion support for core Git
git-diff-cmd.sh         | Enable opendiff to be used with git instead of normal diff
git-pull-all.sh         | Pull all projects within the specified path to the given repository/branch
hostname-change.sh      | Change the hostname permanently
ip-utils.sh             | Validate an IP and check details about it
json-find               | Find a object from the json string or file
pprint-xml              | Pretty print a xml file
toolcheck.sh            | Check if the a tool is installed on the system

**Please check: [bin](./bin) for all scripts**

### 6. HomeSetup Terminal

HomeSetup suggests a terminal profile to use. If you want to, you will need to do the following steps:

* [x] Install the terminal font from '$HOME_SETUP/misc/fonts/Droid-Sans-Mono-for-Powerline-Nerd-Font-Complete.otf'.
* [x] Import the HomeSetup.terminal from "$HOME_SETUP/misc/HomeSetup.terminal" to your Terminal App.
* [x] Set HomeSetup as the default profile.

Done! Now you have your terminal just like mine.

**To keep your HomeSetup updated, don't forget to run `#> dv` sometimes to update (git pull) to the latest code**

