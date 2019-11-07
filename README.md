# HomeSetup
## Terminal .dotfiles and bash improvements for MacOS

### 1. Installation

#### 1.1 Local installation

Clone the repository using the following command:

`#> git clone https://github.com/yorevs/homesetup.git ~/HomeSetup`

And then install dotfiles using the following command:

`#> cd ~/HomeSetup && ./install.bash` => **To install one by one**

or

`#> cd ~/HomeSetup && ./install.bash --all` => **To install all files**

Your old dotfiles (.bash*) will be backed up using '.orig' suffix and sent to ~/.hhs folder.

#### 1.2 Remote installation ( Directly from GitHub )

Use the following command to clone and install the HomeSetup.

`#> curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash`

or

`#> wget -qO- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash`

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

### 2. Uninstallation

If you decide to, you can uninstall al HomeSetup files and restore your old dotfiles. To do that issue the command in a shell: `# HomeSetup> ./uninstall.sh`

The uninstaller will remove all files and foders related to HomeSetup for good.

### 3. Dotfiles in this project

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
~/.colors     : To customize your colors
~/.env        : To customize your environment variables
~/.aliases    : To customize your aliases
~/.prompt     : To customize your prompt
~/.functions  : To customize your functions
~/.profile    : To customize your profile
~/.path       : To customize your paths
```

### 4. Aliases

This project will many aliases (shortcuts) to your shell:

#### Navigational

ALIAS      | Equivalent
---------- | ----------
..         | cd ..
...        | cd ...
....       | cd ....
.....      | cd .....
~          | cd ~
\-         | cd -
?          | pwd

#### General

ALIAS    | Equivalent
-------- | --------
q        | exit
reload   | 'Reload all **.dotfiles**'
pk       | 'Kills all processes matching the specified **<name>**'
sudo     | 'Enable aliases to be **sudo’ed**'
ls       | 'Always use color output for **ls**'
l        | 'List all files colorized in long format'
ll       | 'List all files colorized in long format, including dot files'
lll      | 'List all **.dotfiles**'
lld      | 'List all **.dotfolders**'
lt       | 'List all directories recursively (Nth level depth) as a tree'
grep     | 'Always enable colorized **grep** output'
egrep    | 'Always enable colorized **egrep** output'
fgrep    | 'Always enable colorized **fgrep** output'
rm       | **rm -iv** 'For safety, by default this command will input for confirmation'
cp       | **cp -iv** 'For safety, by default this command will input for confirmation'
mv       | **mv -iv** 'For safety, by default this command will input for confirmation'
cls      | clear
pk       | 'Kills all processes matching <ProcName>'
db-cleanup | 'Recursively delete Dropbox conflicted files from the current directory'
vi       | vim
tl       | 'Tail a log using colors specified in .tailor file.'
df       | df -H
du       | du -hcd 1
more     | more -R
less     | less -R
mount    | 'Make mount command output pretty and human readable format'
mkcd     | Create all folders using a **dot notation path** and immediatelly change into it
cpu      | **top** shortcut ordered by cpu
mem      | **top** shortcut ordered by memory
encode   | base64 encode synonym
week     | 'Current **week** of the month' 
now      | 'Current **date**'
ts       | 'Current **timestamp** in milliseconds'
wget     | 'MacOS has no wget, so use **curl** instead'
rand     | 'Generate a random number from **<min>** to  **<max>**'

#### Python aliases
ALIAS     | Equivalent
--------- | ---------
json_pp   | linux has no **json_pp**, so using python instead
calc      | 'Evaluate mathematical expressions'
urle      | 'URL-encode string'
urld      | 'URL-decode string'
uuid      | 'Generate a random UUID'
utoh      | 'Convert unicode to hexadecimal'

#### Perl aliases
ALIAS     | Equivalent
--------- | ---------
cse       | Clean escape (\EscXX) codes from text
clipboard | Copy to clipboard **pbcopy required**

#### IP related

ALIAS   | Equivalent
------- | -------
ip      | 'Get the Real IP on the internet'
ifa     | 'List all active interfaces on the system' **pcregrep required**
ipl     | 'Get all Local IPs on the local network' **pcregrep required**
ips     | 'Get all (ipv4 & ipv6) associated local IPs of the machine' **ifconfig required**

#### Mac Stuff

ALIAS         | Equivalent
------------- | -------------
ds-cleanup      | 'Delete all **.DS_store** files'
flush         | 'Flush Directory Service cache'
ls-cleanup    | 'Clean up LaunchServices to remove duplicates in the “Open With” menu'
show-files    | '**Show** hidden files in Finder' **defaults required**
hide-files    | '**Hide** hidden files in Finder' **defaults required**
showdeskicons | 'Show all desktop icons'
hidedeskicons | 'Hide all desktop icons'
hd            | 'Canonical hex dump; some systems have this symlinked'
md5sum        | 'macOS has no **md5sum**, so use **md5** as a fallback'
sha1          | 'macOS has no **sha1sum**, so use **shasum** as a fallback'

**Please check: [bash_aliases](./bash_aliases.bash) for all aliases**

### 5. Functions

This project adds many script functions the shell. All functions provide a help using the options -h or --help.

Function    | Purpose
----------- | -----------
encrypt     | Encrypt file using GPG encryption.
decrypt     | Decrypt file using GPG encryption.
hl          | Highlight words from the piped stream.
sf          | Search for **files** and **links to files** recursively.
sd          | Search for **directories** and **links to directories** recursively.
ss          | Search for **strings** matching the specified criteria in files recursively.
hist        | Search for previous issued commands from history using filters.
del-tree    | Move files recursively to the **Trash**.
jp          | Pretty print **(format) JSON** string.
ip-info     | Check information about the specified IP.
ip-resolve  | Resolve domain names associated with the IP.
ip-lookup   | Lookup DNS entries to determine the IP address.
port-check  | Check the state of **local port(s)**.
envs        | Prints all **environment variables** on a separate line using filters.
paths       | Print each **PATH entry** on a separate line.
ver         | Check the **version** of the app using the most common ways.
tc          | Check whether a **tool** is installed on the system.
tools       | Check whether a list of **development tools** are installed.
mselect     | Select an option from a list using a navigable menu.
aa          | Manipulate custom aliases **(add/remove/edit/list)**.
save        | **Save** the one directory to be loaded by *load*.
load        | **Pushd** into a saved directory issued by *save*.
cmd         | Add/Remove/List/Execute saved bash commands.
punch       | Punch the Clock. Add/Remove/Edit/List clock punches.
plist       | Display a process list matching the process name/expression.
godir       | **Pushd** from the first match of the specified directory name.
git-        | GIT Checkout the previous branch in history **(skips branch-to-same-branch changes )**.
sysinfo     | Retrieve relevant system information.
parts       | Exhibit a Human readable summary about all partitions.
hhu          | Check the current **HomeSetup** installation and look for updates..

**Please check: [bash_functions](./bash_functions.bash) for all functions**

### 6. Scripts

The project contains some useful scripts that can be used directly from shell. It is also added to your path variable.

#### 6.1 Python scripts

Function                | Purpose
----------------------- | -----------------------
tcalc.py                | Simple app to do mathematical calculations with time.
free.py                 | Report system memory usage.
json-find.py            | Find an object from the Json string or file.
pprint-xml.py           | Pretty print (format) an xml file.
send-msg.py             | IP Message Sender. Sends UDP/TCP messages using multi-threads.

#### 6.2 Shell scripts

Function                | Purpose
----------------------- | -----------------------
dotfiles.sh             | Manage your HomeSetup .dotfiles and more.
hspm.sh                 | Manage your development tools using installation/uninstallation recipes.
fetch.sh                | Script to fetch REST APIs data.
git-completion.sh       | bash/zsh completion support for core Git.
git-diff-cmd.sh         | Enable opendiff to be used with git instead of normal diff.
git-pull-all.sh         | Pull all projects within the specified path to the given repository/branch.
hostname-change.sh      | Change the hostname permanently.
ip-utils.sh             | Validate an IP and check details about it.
toolcheck.sh            | Check if the a tool is installed on the system.

**Please check: [bin](./bin) for all scripts**

### 7. HomeSetup Terminal

HomeSetup suggests a terminal profile to use. If you want to, you will need to do the following steps:

* [x] Install the terminal font from '$HHS_HOME/misc/fonts/Droid-Sans-Mono-for-Powerline-Nerd-Font-Complete.otf'.
* [x] Import the HomeSetup.terminal from "$HHS_HOME/misc/HomeSetup.terminal" to your Terminal App.
* [x] Set HomeSetup as the default profile.

Done! Now you have your terminal just like mine.

**To keep your HomeSetup updated, run `#> hhu` often, to update (git pull) to the latest HomeSetup code**

