# <img src="https://iili.io/HvtxC1S.png"  width="34" height="34"> HomeSetup

## Your shell, good as hell !

[![License](https://badgen.net/badge/license/MIT/gray)](LICENSE.md)
[![Release](https://badgen.net/badge/release/v1.5.136/gray)](docs/CHANGELOG.md#unreleased)
[![Terminal](https://badgen.net/badge/icon/terminal?icon=terminal&label)](https://github.com/yorevs/homesetup)
[![Gitter](https://badgen.net/badge/icon/gitter?icon=gitter&label)](https://gitter.im/yorevs-homesetup/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Donate](https://badgen.net/badge/paypal/donate/yellow)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=J5CDEFLF6M3H4)

Are you passionate about the terminal? If so, you've come to the right place, especially if you're a command
line enthusiast. Terminal dotfiles are well-known for improving productivity and streamlining everyday tasks. While
there are numerous frameworks available to assist with this, many of them come with a steep learning curve and are
primarily targeted towards individuals with strong programming skills. Additionally, these frameworks often employ
esoteric syntax, requiring an additional effort to fully utilize their features.

Wouldn't it be fantastic if we could effortlessly upload and download our configurations, dotfiles, packages, and
customizations to the cloud? This is where HomeSetup comes in. It provides a solution that simplifies the process,
allowing you to leverage the power of the cloud seamlessly.

With HomeSetup, you can enhance your terminal experience, boost productivity, and customize your setup to suit your
preferences all without the complexities often associated with other frameworks.

For a full list of features, you can access the [HomeSetup usage manual](docs/USAGE.md).

**THIS IT NOT JUST ANOTHER DOTFILES FRAMEWORK**

Please access the [Showcase document](docs/SHOWCASE.md) for demonstrations of usage and features of HomeSetup.

## Highlights

HomeSetup was specifically developed to enhance the command line experience for users. Its primary objective is to provide useful and user-friendly features that expedite daily tasks, such as time tracking, string and file searching, directory navigation, and seamless integration with popular tools like Git, Gradle, Docker, and more.

Key features of HomeSetup include:

- Automated setup for commonly used configurations, ensuring a hassle-free initial setup.
- A wide range of functions to simplify terminal configuration and streamline daily tasks.
- A visually appealing prompt with a monospaced font that supports [Font-Awesome](https://fontawesome.com/) icons.
- Highly customizable **aliases**, allowing users to define their preferred syntax and mnemonics.
- A **universal package manager** helper that facilitates the installation of applications using recipes, catering to various package managers _beyond normal package managers_.
- The ability to save custom dotfiles on [Firebase](https://firebase.google.com/) and easily download them across different environments.
- Offers a short learning curve and provides a comprehensive [User's Handbook](docs/handbook/USER_HANDBOOK.md) for reference.
- All code is licensed under The [MIT License](https://opensource.org/license/mit/), granting users the freedom to modify and use it as desired.
- New Tab completion with Shift key (using menu-complete) to cycle through options conveniently.
- Intuitive visual interfaces for selecting, choosing, and inputting data within scripts.
- Now supports Linux, expanding its compatibility to a wider range of operating systems.
- Can be tried on a [Docker](https://www.docker.com/) container before installing it on your local machine, ensuring a **risk-free trial**.


## Catalina moved from bash to zsh

Starting with the _Catalina_ version of macOS, the default shell has been switched to **Zsh**. Nonetheless, you retain
the flexibility to change the default shell back to bash. To accomplish this, you can utilize the following command:

```bash
$ sudo chsh -s /bin/bash
```

If Apple decides to remove **Bash** from future macOS releases, you can always rely on Homebrew's version. In such cases,
the path to the shell may differ. Here's an alternative approach:

```bash
$ brew install bash
$ sudo chsh -s /usr/local/bin/bash
```

## HomeSetup Python scripts moved to pypi

As HomeSetup evolved over time and expanded, the inclusion of Python scripts became essential. To streamline the
management of the growing [Python](https://www.python.org/) codebase, we recognized the need for a dedicated project.
Introducing **HomeSetup HsPyLib**, a separate project designed specifically for handling all **Python-related
functionality**. You can find the HomeSetup HsPyLib project on PyPI (Python Package Index) at: https://pypi.org/.
HsPyLib comprises _several modules_, each dedicated to a specific purpose, ensuring modular and focused functionality.
Additionally, we have developed a range of highly useful applications as part of the HomeSetup ecosystem. Here is a
list of all the applications managed by HomeSetup:

- [hspylib](https://pypi.org/project/hspylib/) :: HSPyLib - Core python library
- [hspylib-kafman](https://pypi.org/project/hspylib-kafman/) :: HSPyLib - Apache Kafka Manager
- [hspylib-datasource](https://pypi.org/project/hspylib-datasource/) :: HSPyLib - Datasource integration
- [hspylib-vault](https://pypi.org/project/hspylib-vault/) :: HSPyLib - Secrets Vault
- [hspylib-cfman](https://pypi.org/project/hspylib-cfman/) :: HSPyLib - CloudFoundry manager
- [hspylib-firebase](https://pypi.org/project/hspylib-firebase/) :: HSPyLib - Firebase integration
- [hspylib-hqt](https://pypi.org/project/hspylib-hqt/) :: HSPyLib - QT framework extensions
- [hspylib-clitt](https://pypi.org/project/hspylib-clitt/) :: HSPyLib - CLI Terminal Tools

The HsPyLib project is also licensed under the MIT license and is hosted on GitHub at: https://github.com/yorevs/hspylib.

## Table of contents

<!-- toc -->

- [1. Installation](#installation)
  * [1.1. Requirements](#requirements)
    + [1.1.1. Operating systems](#operating-systems)
    + [1.1.1. Supported Shells](#supported-shells)
    + [1.1.2. Required software](#required-software)
      - [1.1.2.1. Darwin and Linux](#darwin-and-linux)
      - [1.1.2.2. Darwin only](#darwin-only)
    + [1.1.3. Recommended software](#recommended-software)
    + [1.1.4. Optional software](#optional-software)
    + [1.1.5. Terminal setup](#terminal-setup)
      - [1.1.5.1. Terminal App](#terminal-app-darwin)
      - [1.1.5.2. iTerm2 App](#iterm2-app-darwin)
  * [1.1. Try-it first](#try-it-first)
  * [1.2. Remote installation](#remote-installation)
  * [1.3. Local installation](#local-installation)
  * [1.4. Firebase setup](#firebase-setup)
    + [1.4.1. Create account](#create-new-account)
    + [1.4.2. Configure account](#configure-account)
- [2. Uninstallation](#uninstallation)
- [3. Support HomeSetup](#support-homesetup)
- [4. Final notes](#final-notes)
- [5. Contacts](#contacts)

<!-- tocstop -->

## Installation

### Requirements

#### Operating Systems

- Darwin
    + High Sierra and higher
- Linux
    + Ubuntu 16 and higher
    + CentOS 7 and higher
    + Fedora 31 and higher

While it's possible to install HomeSetup on **other Linux** distributions and it might work, it's important to note that
**there are no guarantees** of its _full functionality or compatibility_.

#### Supported Shells

- Bash: Everything from 3.2.57(1) and higher.
- Zsh: Zsh is not supported yet.

#### Required software

The following software are required either to clone the repository, execute tests and install all of the packages:

##### Darwin and Linux

- **git** v2.20+ : To clone and maintain the code.
- **sudo** v1.5+ : To enable sudo commands.
- **curl** v7.64+ : To make http(s) requests.
- **vim** v5.0+ : To edit your dotfiles.
- **python** v3.10+ : To run python based scripts.
- **python3-pip** : To install required python packages.
- **pip** v3.10+ : To install python modules.
- **gpg** v2.2+ : To enable encryption based functions.

##### Darwin only

- **brew** v2.0+ : To install the required tools.
- **xcode-select** v2373+: To install command line tools.

##### Ubuntu required packages

- locales
- libpq-dev

##### Fedora required packages

- findutils
- procps
- uptimed
- glibc-common
- net-tools

##### Centos required packages

- wget
- glibc-common
- libpq-devel
- openssl-devel
- bzip2-devel
- libffi-devel

#### Recommended software

HomeSetup depends on a series of tools. To use some of the features of HomeSetup, the following packages are required:

- **bats-core** v0.4+ : To run the automated tests.
- **perl** v5.0+ : To enable perl based functions.
- **dig** v9.10+ : To enable networking functions.
- **tree** v1.8+ : To enable directory visualization functions.
- **ifconfig** v8.43+ : To enable networking functions.
- **hostname** any : To enable hostname management functions.

#### Optional software

If you're a developer, there are several tools that can greatly enhance your workflow. HomeSetup offers a range of
features specifically designed to improve the usage of the following tools:

- **docker** 19.03+ : To enable docker functions.
- **gradle** 4+ : To enable gradle functions.

#### Terminal setup

To fully utilize the Font-Awesome icons in HomeSetup, you'll need a compatible font. We recommend using the font we
provide:

* [Droid font](misc/fonts/Droid-Sans-Mono-for-Powerline-Nerd-Font-Complete.otf).

Before installing or trying HomeSetup, make sure to install this font on your machine. Otherwise, you may see **question
mark icons** instead of the **actual ones**.

**Linux users**: Some terminals already support icons, but if not, you can manually install the font.

**Mac users**: We suggest using one of the terminal profiles listed below to ensure optimal icon display:

##### Terminal App (Darwin)

* Import the HomeSetup-(14|15)-inch.terminal from "$HHS_HOME/misc" to your Terminal App.
* Set HomeSetup as the default profile.

##### iTerm2 App (Darwin)

* Import the iterm2-terminal-(14|15)-inch.json from "$HHS_HOME/misc" to your iTerm2 App.
* Set HomeSetup as the default profile.

### Try-it first

You have the option to run HomeSetup from a [Docker container](https://www.docker.com/), allowing you to evaluate its
functionality before deciding to install it on your machine. To do this, follow these steps:

1. Start by pulling the Docker image you wish to try by executing one of the following commands:
    ```bash
    $ docker run --rm -it yorevs/hhs-centos
    $ docker run --rm -it yorevs/hhs-ubuntu
    $ docker run --rm -it yorevs/hhs-fedora
    ```

2. Once the image is successfully pulled, you can proceed to run HomeSetup within the Docker container, explore its features, and evaluate its suitability for your needs.

Running HomeSetup in a Docker container offers a convenient and isolated environment for testing purposes, ensuring
that your machine remains unaffected during the evaluation process.

### Remote installation

This is the recommended installation method. You can install HomeSetup directly from GitHub by executing onr of the
following commands:

`$ curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash`

or

`$ wget -qO- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash`

### Local installation

Clone the HomeSetup repository:

`$ git clone https://github.com/yorevs/homesetup.git ~/HomeSetup`

And then install all dotfiles using the following command:

`$ cd ~/HomeSetup && ./install.bash` => **To install all files at once**

or

`$ cd ~/HomeSetup && ./install.bash -i` => **To install one by one**

Your existing dotfiles (such as .bashrc, .bash_profile, etc.) will be backed up with the **'.orig'** suffix and stored
in the **~/.hhs/backup** folder. This ensures that your original dotfiles are safely preserved during the installation
process.

### Post-Installation

Once the installation is completed successfully, you should see the following welcome message:

![HomeSetup Welcome](https://iili.io/H8lOPxS.png "Welcome to HomeSetup")

### Firebase setup

HomeSetup provides the capability to utilize your Firebase account for uploading and downloading your custom files
(dotfiles file synchronization) to your *Real-time Database*. To utilize this feature, you must first configure your
Google Firebase account.

#### Create new account

If you have a Google account but don't have a Firebase account yet, you can create one using your Google credentials.

Access: [https://console.firebase.google.com/](https://console.firebase.google.com/)

1. Create a *new Project* (HomeSetup).
2. Create a Database (in **production mode**):
   - Go to Develop -> Database -> Create Database.
   - Select **Real-time Database**.
   - Navigate to the **Rules** tab.
3. Add the following rule to your HomeSetup **ruleset**.

Visit https://firebase.google.com/docs/database/security to learn more about security rules.

```json
{
  "rules": {
    "homesetup": {
      ...
      "dotfiles": {
        ".read": "false",
        ".write": "false",
        "$uid" : {
            ".read": "true",
            ".write": "true"
          }
        },
      ...
    }
  }
}
```

#### Configure account

To configure your Firebase account for use with HomeSetup, follow these steps:

1. Configure the read and write permissions as shown in section [1.3.1.](#create-new-account) of the documentation.
2. Access your account from: [https://console.firebase.google.com/](https://console.firebase.google.com/)
3. Create a service key to **enable read/write access** to your Firebase account:

   - Click on *Authentication* in the left menu, then select *Users*.
   - Obtain your **USER UID** and Identifier (email).
   - Click on the *cogwheel icon* and choose *Project settings*.
   - Go to the *Service accounts* tab.
   - Obtain your **Project ID**.
   - Click on *Generate new private key*.
   - Save the generated file into the **$HHS_DIR** directory (usually ~/.hhs).
   - Rename the file to *<project-id>-firebase-credentials.json*.

   For more details, consult the [Firebase help page](https://console.firebase.google.com/u/1/project/homesetup-37970/settings/serviceaccounts/adminsdk).

4. In a shell, run the command `$ firebase setup` and fill in the setup form as follows:

   ![Firebase Setup](https://iili.io/H8ll1pa.png "Firebase Setup")

You have now successfully configured Firebase for use with HomeSetup. To learn more about using Firebase features,
type in your shell:

`$ firebase help`

## Uninstallation

If you choose to uninstall HomeSetup and restore your old dotfiles, you can do so by issuing the following command
in a shell:

`# HomeSetup> ./uninstall.bash`

The uninstaller will remove all files and folders associated with HomeSetup. The only folder that will remain is
the $HHS_DIR (~/.hhs typically), whereas your configurations were stored. After a successful uninstallation, it is safe
to delete this folder if you no longer need it, **HOWEVER ALL CUSTOM DOTFILES WILL BE GONE**.

## Support HomeSetup

You can support HomeSetup by [donating](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=J5CDEFLF6M3H4)
or contributing code. Feel free to contact me for further details. When making code contributions, please make sure to
review our [guidelines](docs/CONTRIBUTING.md) and adhere to our [code of conduct](docs/CODE_OF_CONDUCT.md).

Your support and contributions are greatly appreciated in helping us improve and enhance HomeSetup. Together, we can
make it even better!

## Sponsors

This project is supported by:

<a href="https://www.jetbrains.com/community/opensource/?utm_campaign=opensource&utm_content=approved&utm_medium=email&utm_source=newsletter&utm_term=jblogo#support">
  <img src="https://resources.jetbrains.com/storage/products/company/brand/logos/jb_beam.png" width="120" height="120">
</a>

[![DigitalOcean Referral Badge](https://web-platforms.sfo2.digitaloceanspaces.com/WWW/Badge%203.svg)](https://www.digitalocean.com/?refcode=a46eac913a06&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

Thank you for your support <3 !!

## Final notes

HomeSetup is designed to automatically fetch updates **every 7 days** from the time of installation. However, if you
want to manually ensure that your HomeSetup is up to date, you can run the following command in your terminal:

`$ hhs updater execute update`.

This will install the latest version of HomeSetup, keeping your setup current and incorporating any new features and
improvements. Keeping HomeSetup updated is essential to benefit from the latest enhancements and bug fixes. If you have
any questions or encounter any issues during the update process, feel free to reach out for assistance.

## Contacts

- Documentation: [API](docs/handbook/USER_HANDBOOK.md)
- License: [MIT](LICENSE.md)
- Code: https://github.com/yorevs/homesetup
- Issue tracker: https://github.com/yorevs/homesetup/issues
- Official chat: https://gitter.im/yorevs-homesetup/community
- Contact: https://www.reddit.com/user/yorevs
- Mailto: [Yorevs](mailto:homesetup@gmail.com)


Happy scripting with HomeSetup!
