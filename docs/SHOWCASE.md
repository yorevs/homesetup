<img src="https://iili.io/HvtxC1S.png" width="64" height="64" align="right" />

# HomeSetup Showcase
> The ultimate Terminal experience

## How can I try it ?

There are two ways of trying HomeSetup:

### Local installation:

```bash
$ curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash
```

or

```bash
$ wget -qO- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash
```

### Run on Docker

If you're uncertain about the changes that the installation may bring or prefer to try it out in a controlled
environment, you can opt for the **Docker method**. By using it, you can run HomeSetup within a container without
affecting your host system. This allows you to experiment and evaluate the installation before making any permanent
changes. You can try HomeSetup on Docker, issuing one of the following commands:

```bash
$ docker run --rm -it yorevs/hhs-centos
$ docker run --rm -it yorevs/hhs-ubuntu
$ docker run --rm -it yorevs/hhs-fedora
$ docker run --rm -it yorevs/hhs-alpine
```

![HomeSetup Welcome](https://iili.io/H8ry3vI.png "Welcome to HomeSetup")

# HomeSetup's purpose

HomeSetup, created in **August 17, 2018**, is a comprehensive bundle of scripts and dotfiles designed to elevate your
**bash shell** experience to new heights. Packed with numerous enhancements and developer-friendly features, HomeSetup
is geared towards streamlining your workflow and significantly boosting productivity. Currently, it offers robust
support for Bash (version 3.4+) on both _macOS_ and _Linux_ platforms. Moreover, we have exciting plans to extend
support for [Zsh](https://www.zsh.org/) in the near future, catering to a wider range of users. If you're seeking a
more powerful and efficient shell experience, HomeSetup is the perfect solution.

## Create your own syntax

HomeSetup is designed to prioritize a seamless user experience, making installation and usage easy for everyone.
It aims to create a familiar environment across different machines, ensuring that you feel at home regardless of where
you're working. Beyond being a dotfiles framework, it serves as a comprehensive ecosystem that assists in configuring
various aspects of your terminal environment.

With HomeSetup, you gain access to a wide range of shell utilities, aliases, and commands that cater to both regular
users and skilled developers. It's an open-source project that emphasizes sharing knowledge and simplifying tasks.
Some of its key features include time-tracking functionality, the ability to save customizations on the cloud, a
universal package manager syntax that works across different operating systems, and much more.

One of the standout aspects of HomeSetup is its flexibility. You have the freedom to create your own syntax by modifying
the default **alias definitions**, tailoring it to your specific needs. Additionally, HomeSetup offers pre-built
applications that assist with daily tasks, such as uploading custom dotfiles to the cloud, installing packages with
ease (_even without prior knowledge_), and securely storing secrets. The project also supports plug-ins and plugable
functions, allowing for easy integration and customization.

Out-of-the-box, HomeSetup provides several plug-ins that extend its capabilities:

- **HSPM**: A tool for managing your development tools using installation and uninstallation recipes.
- **FIREBASE**: A manager for integrating HomeSetup with Firebase.
- **UPDATER**: A HomeSetup update manager that keeps your installation up to date.
- **SETMAN**: A settings manager allowing you to easily changed/add/remove settings and converting them to .envrc or environment variables.

When you initially run HomeSetup, you'll start with a clean slate without any customizations. However, as you use the
tool, you'll have the opportunity to create your own dotfiles and make tweaks to tailor the experience to your liking.
The power and versatility of HomeSetup are best demonstrated through its various features and functionalities.

Feel free to explore HomeSetup, experiment with its capabilities, and unleash its magic to enhance your productivity
and streamline your workflow.

[![HomeSetup-Overview](https://asciinema.org/a/582590.svg)](https://asciinema.org/a/582590)

## Creating your custom dotfiles

HomeSetup provides a structured organization for dotfiles, categorizing them into seven distinct categories:

1. **Aliases** (`~/.aliases`): This file contains custom aliases that can be created or overridden to suit your needs.
2. **Environment Variables** (`~/.env`): Here, you can define environment variables specific to your setup.
3. **Paths** (`~/.path`): The `~/.path` file allows you to customize the system paths used by your shell.
4. **Prompt** (`~/.prompt`): Customize your shell prompt by editing the `~/.prompt` file.
5. **Colors** (`~/.colors`): This file lets you define custom color schemes for your terminal.
6. **Functions** (`~/.functions`): Define your own custom functions in the `~/.functions` file.
7. **Personal Profile** (`~/.profile`): The `~/.profile` file serves as your personal profile, where you can include additional configurations or source your custom dotfiles.

Within HomeSetup, there are specific manager applications for some of the custom dotfiles:

1. `__hhs_envs`: Manages the custom environment variables defined in `~/.env`.
2. `__hhs_paths`: Handles the custom paths defined in `~/.path`.
3. `__hhs_aliases`: Manages the custom aliases defined in `~/.aliases`.

To make your experience more convenient, it utilizes a set of aliases that provide shortcuts to most of the `__hhs`
functions. These aliases are defined in the `.aliasdef` file located in the `$HHS_DIR` folder. While you have the
flexibility to manually edit this file, for the sake of this demonstration, the default definitions will be used.

You can watch a demo of some of HomeSetup's features in the asciicast below:

[![HomeSetup-Aliases](https://asciinema.org/a/583777.svg)](https://asciinema.org/a/583777)

Please note that custom dotfiles are partially supported by HomeSetup. While you can create them, you will need to
source them manually. It is recommended to include your custom dotfiles in the `.profile` file for easy sourcing and
integration with HomeSetup. Feel free to explore and modify the custom dotfiles according to your preferences,
leveraging the power and flexibility of HomeSetup to create a tailored and efficient terminal environment.

## Saving your dotfiles on the cloud

HomeSetup offers seamless integration with [Firebase Realtime Database](https://firebase.google.com/), allowing you to
securely save and load all of your dotfiles. This feature ensures that your setup is backed up using Google's powerful
realtime database capabilities.

### Firebase

Please check the [Firebase Setup](FIREBASE_SETUP.md) document for instructions on how to configure your account.

Once configured, you can use Firebase to upload/download your dotfiles to/from Firebase. This allows ou to have all of
your dotfiles everywhere.

<img src="https://iili.io/JuzoPwb.png" />

<img src="https://iili.io/JuzIzG4.png" />

### Starship

HomeSetup provides an out-of-the-box starship.toml, but you can configure it the way you want byt typing:

`$ hhs starship`

or just

`$ starship`

If you are lazy to configure yourself, you can try on the the Starship presets:

`$ starship preset`

<img src="https://iili.io/JuzfXf9.png"/>

<img src="https://iili.io/JuzBxCN.png" />

# Shell is boring, I prefer a graphical interface

Indeed, graphical user interfaces (GUIs) can be helpful when getting started with a new application. However, they
often hide the advanced features and functionalities of the underlying tool. What if you could have the convenience of
a visual interface, similar to a command line, without the need to install numerous packages?

With HomeSetup, you can experience a user-friendly interface that harnesses the power of the command line. It provides
a streamlined and efficient way to access and utilize advanced features, all within a familiar terminal environment.
HomeSetup eliminates the need for excessive package installations, allowing you to focus on maximizing the capabilities
of the underlying tools.

By leveraging the command line interface of HomeSetup, you can explore the full potential of the application while
maintaining the simplicity and efficiency of a visual interface. Enjoy the best of both worlds with HomeSetup's
intuitive and feature-rich command line experience.

[![HomeSetup-TUI](https://asciinema.org/a/586008.svg)](https://asciinema.org/a/586008)

[The HomeSetup](https://github.com/yorevs/homesetup) team is dedicated to crafting their own tools using a combination
of shell script and Python. These custom tools are designed to enhance the functionality of HomeSetup and provide a
seamless user experience. When it comes to dependencies, the HomeSetup team strives to utilize widely adopted
open-source options such as **gpg** and **curl**. By leveraging these popular tools, it ensures compatibility
and accessibility for a wide range of users.

Furthermore, the tools developed by the team are not limited to internal usage only. They are made readily
available for you to incorporate into your own scripts and workflows. This allows you to leverage the power and
convenience of HomeSetup's tools in your own customizations and projects.

With HomeSetup, you not only benefit from a comprehensive set of pre-built tools but also gain the flexibility and
extensibility to create your own solutions using the same principles and techniques.

# Small learning curve

All the information you need to understand and utilize HomeSetup can be found in the comprehensive [User Handbook](https://github.com/yorevs/homesetup/blob/master/docs/handbook/handbook.md).
This handbook provides detailed documentation for every aspect of HomeSetup, including usage instructions, examples,
and explanations of various features and functionalities. It serves as a valuable resource to guide you through the
installation, configuration, and usage. Additionally, each function is equipped with a built-in help. By appending
`-h` or `--help` to the `__hhs_<function>` command, you can access specific help information for that particular
function or application. This allows you to quickly understand the purpose, usage, and available options of each
function without referring to external documentation.

To ensure a clear distinction and prevent conflicts with existing configurations, most of HomeSetup's aliases, commands,
and environment variables are prefixed with '__hhs_' or 'HHS_'. This consistent naming convention makes it easy to
identify HomeSetup-related components and prevents any unintended interference with your existing setup. You can rely
on these prefixes to locate and manage HomeSetup elements with confidence.

By referring to the User Handbook and utilizing the built-in function helps, you have access to comprehensive
documentation that empowers you to leverage the full potential of HomeSetup. Whether you're exploring new features or
customizing your setup, these resources provide the information you need to make the most of HomeSetup's capabilities.
