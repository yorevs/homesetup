# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][kac] and this project adheres to [Semantic Versioning][semver].

    [kac]: https://keepachangelog.com/en/1.0.0/
    [semver]: https://semver.org/

    ## Unreleased

    ### Added

    ### Fixed

    ### Updated

    ### Removed


## 1.6.1 - 2023-09-19

## Unreleased

### Added

### Fixed

### Updated

### Removed


## 1.5.1 - 2020-01-21

### Added

* Added Adoptium (java) recipe for Linux
* Added Dockefiles for ubuntu and centos
* Added Github Actions
* Added HS icon to all handbook pages
* Added Publish Workflow
* Added __hhs_hist_stats new command
* Added _which_ to Darwin hspm recipes
* Added applications handbook - part2
* Added badgen.gradle and README update
* Added cleanup option to save_dir
* Added colima recipe for Darwin
* Added default args for ss, sf, sd
* Added details about how to configure the service key
* Added docker recipe for linux
* Added env firebase cert file
* Added fedora to docker and to supported os
* Added gcc to docker agent
* Added gradle, fix bats tests and install.bash
* Added hhs clear function
* Added hhs clear to clear logs , backups and caches
* Added hhs welcome message to the containers
* Added included HEAD to fetch
* Added jenkins recipe for linux - fix - 5
* Added log dir if it does not yet exist
* Added master-unlock to .gitignore
* Added multiple builds
* Added new env about the os package manager
* Added nginx configurations for HomeSetup
* Added pull request template
* Added setman integration
* Added setman->settings
* Added the ci-pipelines
* Added the docker-agent Dockerfile
* Added updateMinor to the publish action

### Fixed

* Fixed .path not being exported
* Fixed CentOs install since yum does not have python and pip but pip2/3 python2/3
* Fixed Darwin installation scripts
* Fixed Firebase fixes (also from hspylib)
* Fixed Github Actions - 1
* Fixed Give default value for $TEMP
* Fixed HANDBOOK for mchoose and mselect
* Fixed HandBook navigation
* Fixed README docs
* Fixed README links and hhs host-name
* Fixed Readmes and docs
* Fixed Uninstall script
* Fixed __hhs_settings
* Fixed about when the command is not aliased
* Fixed aliases and paths
* Fixed and improve hhs logs
* Fixed bats tests
* Fixed branch mismatch and use new mselect on all functions
* Fixed default firebase config file
* Fixed documentation and hhs app
* Fixed duplicated paths and aa
* Fixed encrypt/decrypt python lib
* Fixed envs name=value separation
* Fixed file_path problem due to pycharm refactoring
* Fixed firebase app
* Fixed firebase setup
* Fixed fonts directory installation
* Fixed installation script
* Fixed git pull all not reading all selected indexes
* Fixed godir when there's only one match
* Fixed gradle publish
* Fixed hhs funcs
* Fixed hhs host-name
* Fixed hhs host-name -> ised problems
* Fixed hspm - 1
* Fixed hspm default recipes and tcalc.py error
* Fixed hspm not to use __hhs_open
* Fixed install links
* Fixed install/uninstall regarding hspylib
* Fixed installation and tailor. Also, use tailor to get hhs logs
* Fixed installation process. Fix an issue that was not updating the hspylib to latest version. New prompt icon
* Fixed installation required tools
* Fixed installation script -> hhs prefix - 1
* Fixed installation script IFS
* Fixed installation script to activate dotfiles
* Fixed installation script to display the user:group
* Fixed missing - , -r in tailor
* Fixed now hspm drop breadcrumb based on my_os_release
* Fixed os release info
* Fixed paths and some other bugs
* Fixed prompt icons
* Fixed prompts
* Fixed publish action
* Fixed publish action -> install bumpver
* Fixed publish gradle and action
* Fixed punch -> tcalc issue
* Fixed python scripts
* Fixed removed debug echos
* Fixed settings by allowing setting name to source
* Fixed some firebase setup problems
* Fixed terminal settings
* Fixed test pipeline stage
* Fixed the firebase without args
* Fixed the publish action message
* Fixed the publish action to allow select tagging and updating major
* Fixed the settings hhs plugin
* Fixed toc bullet
* Fixed uninstallation script
* Fixed various bugs: godir, firebase.py plugin and hspylib
* Fixed welcome message and README with the Terminal font config

### Updated

* Updated applications handbook.
* Updated Install improvements and hspm improvements due to sudo.
* Updated HomeSetup documents.
* Updated hhsrc load. Improving hhsrc load, logs and compatibility.
* Updated installation of python libs and scripts.
* Updated python script into HSPyLib project.
* Removed python apps docs, add vault and firebase to install/uninstall and alias fix for them.
* Updated replacing .aliasdef for every installation.
* Updated executables hspylib to clitt.
* Updated HS logo.
* Updated bash_prompts.
* Updated documentation and hhs app.
* Updated install script for docker build.
* Updated Dockerfiles for ubuntu, centos and fedora.
* Updated HomeSetup README sync. Pending hhs app handbook.

### Removed

* Removed firebase.properties and .last_update from being uploaded into Firebase
* Removed .github folder. Moved contents to docs folder
* Removed GREP_COLOR env set
* Removed Jenkins pipelines
* Removed TODO removed. Issue moved to GitHub issues board
* Removed dev stuff from docker-agent
* Removed git hook from installation
* Removed gradle.bat
* Removed old development images
* Removed python apps and plugins (files) using hspylib now
* Removed python apps docs, add vault and firebase to install/uninstall and alias fix for them
* Removed unrelated font
* Removed vault plugin and firebase init

## 1.4.1 - 2020-01-21

### Added

* Added New vim recipe.
* Added New function __hhs_minput based on __hhs_mselect.
* Added New compatibility with **semver** from the next release.
* Added New CHANGELOG.md file and USER_HANDBOOK.md scratch.
* Added New __hhs_ascof function.
* Added New commit_msg git hook.
* Added Deployer tool scratch.
* Added Linux compatibility.
* Added hhs python library.
* Added a user handbook.

### Fixed

* Fixed __hhs_git_pull_all from failing when the repository was not being tracked on remote.
* Fixed HHS-App updater check when local version was greater than the repository version.
* Fixed for ip-utils.bash and renaming it to check-ip.bash.
* Fixed many IFS problems.
* Fixed python scripts for versions 2.7 and 3.0.
* Fixed install.sh and uninstall.sh scripts.
* Fixed a bug where the outfile was not being picked correctly (__hhs_mselect, __hhs_mchoose and __hhs_minput).
* Fixed installation when git clone was not called before the dotfiles search and font copy.
* Fixed prepared_commit_message git hook
* Fixed __hhs_docker_kill_all stopping at first error.
* Fixed all non-Linux compatible scripts, functions and aliases.
* Fixes various bugfixes and improvements.

### Updated

* Updated README.md to match latest changes of HomeSetup.
* Updated Improved installation and compatibility.
* Updated Hspm plugin now accepts multiple installs/uninstalls.
* Updated Improved HHS-App. Separating local functions into a separate folder and 'plug-able' files.
* Updated Moved the script git-pull-all.bash into an __hhs<function>.
* Updated Improved __hhs_mselect, __hhs_mchoose and __hhs_minput when reading arrays. Removing SC2206 disable.
* Updated Moved hostname-change to a HHS-App function.
* Updated Moved the file ~/.path into ~/.hhs .
* Updated HHS-App hspm plugin now tries to install using brew if recipe was not found.
* Updated Improved HHS-App firebase plugin configuration.
* Updated Enforcing changelog words to commit messages.
* Updated Prompt style PS1 from $> to $
* Updated auto-completions: reformatting with 2 spaces.
* Updated improved alias documentations. Added a tag @alias to be found later by the deployer tool.
* Updated Improved firebase plugin: it's now python instead of bash.

## 1.3.1 - 2020-01-21

### Added

* Added New auto-complete (menu_complete) to <shift-tab> strokes.
* Added Brew bash/zsh as options for __hhs_shell_select.
* Added New function __hhs_mchoose based on __hhs_mselect.
* Added New function __hhs_change_dir to replace the old cd command.
* Added New HHS-App updater plug-in.
* Added New PCF-Completion.
* Added New docker lazy init function.
* Added New vt100 code cheat sheet.

### Fixed

* Fixed all references of `ised' without -E not finding anything.
* Fixed __hhs_punch: Various bugfixes.
* Fixed __hhs_search_string: Fix ss with spaces inside search string when hl the string.
* Fixed Install/Uninstall script were not working properly.
* Fixed __hhs_git_branch_select: Fixed the branch change when remote branch was selected.
* Fixed __hhs_mselect: bugfixes and upgrade.
* Fixed Important fixes to __hhs_alias, __hhs_save, __hhs_aliases, __hhs_paths and __hhs_command regarding the result arrays.

### Updated

* Updated Improved __hhs_punch with new balance field and visual.
* Updated Improved HHS-App: Added local and hhs functions.
* Updated Improved function and app helps.
* Updated the HHS welcome message to be a MOTD file.
* Updated Extending __hhs_sysinfo and moving IP aliases into a separate file.
* Updated Rename all hspm recipes to *.recipe.
* Updated Improved taylor to match some patterns correctly and color adjustments.

### Removed
* Removed **HHS_MAXDEPTH** from all functions and the env var.
