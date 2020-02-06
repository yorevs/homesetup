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

Type in a shell: `#> dotfiles.bash fb setup`

Fill in the information required.
You are now ready to use the Firebase features of HomeSetup.
Type: `#> dotfiles.bash help fb` for further information about using it.

### 2. Uninstallation

If you decide to, you can uninstall al HomeSetup files and restore your old dotfiles. To do that issue the command in a shell: `# HomeSetup> ./uninstall.bash`

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
~/.colors           : To customize your colors
~/.env              : To customize your environment variables
~/.aliases          : To customize your aliases
~/.prompt           : To customize your prompt
~/.functions        : To customize your functions
~/.profile          : To customize your profile
~/.path             : To customize your paths
~/.aliasdef    : To customize your alias definitions
```

### 4. Aliases

%ALIASES%

### 5. Functions

%FUNCTIONS%

### 6. Apps

%APPS%

### 7. HomeSetup Terminal setup

#### 7.1 Terminal.app

HomeSetup suggests a terminal profile to use. If you want to, you will need to do the following steps:

* [x] Install the terminal font from '$HHS_HOME/misc/fonts/Droid-Sans-Mono-for-Powerline-Nerd-Font-Complete.otf'.
* [x] Import the HomeSetup.terminal from "$HHS_HOME/misc/HomeSetup.terminal" to your Terminal App.
* [x] Set HomeSetup as the default profile.

#### 7.2 iTerm2.app

TODO: https://www.iterm2.com/features.html

Done! Now you have your terminal just like mine.

**To keep your HomeSetup updated, run `#> hhu` often, to update (git pull) to the latest HomeSetup code**

