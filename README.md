<img src="https://iili.io/HvtxC1S.png" width="64" height="64" align="right" />

# HomeSetup
> The ultimate Terminal experience

[![Terminal](https://badgen.net/badge/icon/terminal?icon=terminal&label)](https://github.com/yorevs/homesetup)
[![License](https://badgen.net/badge/license/MIT/gray)](LICENSE.md)
[![Release](https://badgen.net/badge/release/v1.6.19/gray)](docs/CHANGELOG.md#unreleased)
[![Gitter](https://badgen.net/badge/icon/gitter?icon=gitter&label)](https://gitter.im/yorevs-homesetup/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Donate](https://badgen.net/badge/paypal/donate/yellow)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=J5CDEFLF6M3H4)
[![Build](https://github.com/yorevs/homesetup/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/yorevs/homesetup/actions/workflows/build-and-test.yml)

Are you passionate about the terminal and CLI? If so, you've come to the right place, especially if you're a command
line enthusiast. Terminal dotfiles are well-known for improving productivity and streamlining everyday tasks. While
there are numerous frameworks available to assist with this, many of them come with a steep learning curve and are
primarily targeted towards individuals with strong programming skills. Additionally, these frameworks often employ
esoteric syntax, requiring an additional effort to fully utilize their features.

Wouldn't it be fantastic if we could effortlessly upload and download our configurations, dotfiles, packages, and
customizations to the cloud? This is where HomeSetup comes in. It provides a solution that simplifies the process,
allowing you to leverage the power of the cloud seamlessly.

With **HomeSetup**, you can enhance your terminal experience, boost productivity, and customize your shell to suit your
preferences all without the complexities often associated with other frameworks. HomeSetup was specifically developed
to enhance the command line experience for users. Its primary objective is to provide useful and user-friendly features
that expedite daily tasks, such as time tracking, string and file searching, directory navigation, and seamless
integration with popular tools like Git, Gradle, Docker, and more.

> **THIS IT NOT JUST A DOTFILES FRAMEWORK**

- See the [Showcase](docs/SHOWCASE.md) page to see some HomeSetup demos.
- For the full documentation, access the [HomeSetup usage manual](docs/USAGE.md).

## Key Features

- <img src="https://starship.rs/icon.png" width="14" height="14"/> [Starship](https://starship.rs/) prompt is here! HomeSetup now integrates with Starship.
- Automated setup for commonly used configurations, ensuring a hassle-free initial setup.
- A wide range of functions to simplify terminal configuration and streamline daily tasks.
- A visually appealing prompt with a monospaced font that supports [Font-Awesome](https://fontawesome.com/) icons (requires a [Nerd font](https://www.nerdfonts.com/)).
- Highly customizable **aliases**, **paths**, **environment variables** and more.
- A **universal package manager** helper that facilitates the installation of applications using recipes, catering to various package managers _beyond normal package managers_.
- Ability to upload custom dotfiles on [Firebase](https://firebase.google.com/) and easily download them across different environments.
- Offers a short learning curve and provides a comprehensive [User's Handbook](docs/handbook/USER_HANDBOOK.md) for reference.
- All code is licensed under The [MIT License](https://opensource.org/license/mit/), granting users the freedom to modify and use it as desired.
- Tab completion with Shift key (using menu-complete) to cycle through options conveniently.
- Intuitive visual input methods for selecting, choosing, and form data within scripts.
- Supports Linux and macOS, expanding its compatibility to a wider range of operating systems.
- Can be tried on a [Docker](https://hub.docker.com/repository/docker/yorevs/hhs-fedora/general) container beforehand, ensuring a **risk-free trial**.


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

## Installation


### Operating Systems

- Darwin (macOS)
    + High Sierra and higher
- Linux
    + Ubuntu 16 and higher
    + CentOS  7 and higher
    + Fedora 31 and higher
    + Alpine

> While it's possible to install HomeSetup on **other Linux** distributions and it might work, it's important to note that
**there are no guarantees** of its _full functionality or compatibility_.


### Supported Shells

- Bash: Everything from 3.2.57(1) and higher.
- Zsh: Zsh is planned but not supported yet.

### Terminal configuration

To visualize the Font-Awesome unicode icons, you'll need a compatible nerd font. We recommend using the font we
provide with the installation:

* [Droid font](misc/fonts/Droid-Sans-Mono-for-Powerline-Nerd-Font-Complete.otf).

**Linux users**: Some terminals already support icons, but if not, you can manually install the font.

**Mac users**: We suggest using one of the terminal profiles listed below to ensure optimal icon display:

#### Terminal App (Darwin)

* [HomeSetup Terminal](misc/HomeSetup.terminal)

#### iTerm2 App (Darwin)

* [HomeSetup iTerm2](misc/iTerm2-HomeSetup.json)


When your terminal is set, then you should see something like this:

<img src="https://iili.io/JuxHulR.png" />


### Try-it first

Running HomeSetup in a Docker container offers a convenient and isolated environment for testing purposes, ensuring
that your machine remains unaffected during the evaluation process. Use one of the following image below:

```bash
$ docker run --rm -it yorevs/hhs-centos
$ docker run --rm -it yorevs/hhs-ubuntu
$ docker run --rm -it yorevs/hhs-fedora
$ docker run --rm -it yorevs/hhs-alpine
```

### Remote installation

This is the recommended installation method. You can install HomeSetup directly from GitHub by executing one of the following commands:

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

Once the installation is completed successfully, you should see the following welcome message:

![HomeSetup Welcome](https://iili.io/JuxFH3G.png "Welcome to HomeSetup")


### Firebase setup

HomeSetup provides the capability to utilize your Firebase account for uploading and downloading your custom files
(dotfiles file synchronization) to your *Real-time Database*. To utilize this feature, you must first configure your
Google Firebase account. Please check the [Firebase Setup](docs/FIREBASE_SETUP.md) document for instructions.

### Starship Setup

HumeSetup, now, bundles starship prompt. It's has an out-of-the-box configuration. For a full list of features and configurations please checkout the [Starship](https://starship.rs/) website.


## Uninstallation

If you choose to uninstall HomeSetup and restore your old dotfiles, you can do so by issuing the following command
in a shell:

`# HomeSetup> ./uninstall.bash`

The uninstaller will remove all files and folders associated with HomeSetup. The only folder that will remain is
the $HHS_DIR (~/.hhs typically), whereas your configurations were stored. After a successful uninstallation, it is safe
to delete this folder if you no longer need it, **HOWEVER ALL CUSTOM DOTFILES WILL BE GONE**.

## Support

You can support HomeSetup by [donating](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=J5CDEFLF6M3H4)
or contributing code. Feel free to contact me for further details. When making code contributions, please make sure to
review our [guidelines](docs/CONTRIBUTING.md) and adhere to our [code of conduct](docs/CODE_OF_CONDUCT.md).

> Your support and contributions are greatly appreciated in helping us improve and enhance HomeSetup. Together, we can
make it even better!

This project is already supported by:

<a href="https://www.jetbrains.com/community/opensource/?utm_campaign=opensource&utm_content=approved&utm_medium=email&utm_source=newsletter&utm_term=jblogo#support">
  <img src="https://resources.jetbrains.com/storage/products/company/brand/logos/jb_beam.png" width="120" height="120">
</a>

Thank you <3 !!

## Final notes

HomeSetup is designed to automatically fetch updates **every 7 days** from the time of installation. However, if you
want to manually ensure that your HomeSetup is up to date, you can run one of the following command in your terminal:

`$ hhs updater execute update`

or just

`$ hhu`

This will install the latest version of HomeSetup, keeping your setup current and incorporating any new features and
improvements. Keeping HomeSetup updated is essential to benefit from the latest enhancements and bug fixes. If you have
any questions or encounter any issues during the update process, feel free to reach out for assistance.

## Known Issues

- [In-Progress] We are aware that there is a problems when using python@3.12 and we are already working on a fix.

## Contacts

- Documentation: [API](docs/handbook/USER_HANDBOOK.md)
- License: [MIT](LICENSE.md)
- Issue tracker: https://github.com/yorevs/homesetup/issues
- Official chat: https://gitter.im/yorevs-homesetup/community
- Maintainer: https://www.reddit.com/user/yorevs
- Mailto: [HomeSetup](mailto:homesetup@gmail.com)


Enjoy!
