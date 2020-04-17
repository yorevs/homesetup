# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][kac] and this project adheres to
[Semantic Versioning][semver].

[kac]: https://keepachangelog.com/en/1.0.0/
[semver]: https://semver.org/


## Unreleased

### Added

* New vim recipe.
* New function __hhs_minput based on __hhs_mselect.
* New compatibility with **semver** from the next release.
* New CHANGELOG.md file and USER_HANDBOOK.md scratch.
* New __hhs_ascof function.
* New commit_msg git hook.
* Deployer tool scratch.

### Changed

* Updated README.md to match latest changes of HomeSetup.
* Improved installation and compatibility.
* Hspm plugin now accepts multiple installs/uninstalls.
* Improved HHS-App. Separating local functions into a separate folder and 'plug-able' files.
* Moved the script git-pull-all.bash into an __hhs<function>.
* Improved __hhs_mselect, __hhs_mchoose and __hhs_minput when reading arrays. Removing SC2206 disable.
* Moved hostname-change to a HHS-App function.
* Moved the file ~/.path into ~/.hhs .
* HHS-App hspm plugin now tries to install using brew if recipe was not found.
* Improved HHS-App firebase plugin configuration.
* Enforcing changelog words to commit messages.
* Prompt style PS1 from $> to $
* Changed auto-completions: reformatting with 2 spaces.
* Changed improved alias documentations. Added a tag @alias to be found later by the deployer tool.

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


## 1.3.0 - 2020-01-21

### Added

* New auto-complete (menu_complete) to <shift-tab> strokes.
* Brew bash/zsh as options for __hhs_shell_select.
* New function __hhs_mchoose based on __hhs_mselect.
* New function __hhs_change_dir to replace the old cd command.
* New HHS-App updater plug-in.
* New PCF-Completion.
* New docker lazy init function.
* New vt100 code cheat sheet.

### Changed

* Improved __hhs_punch with new balance field and visual.
* Removed **HHS_MAXDEPTH** from all functions and the env var.
* Improved HHS-App: Added local and hhs functions.
* Improved function and app helps.
* Changed the HHS welcome message to be a MOTD file.
* Extending __hhs_sysinfo and moving IP aliases into a separate file.
* Rename all hspm recipes to *.recipe.
* Improved taylor to match some patterns correctly and color adjustments.
* Fixed all references of `ised' without -E not finding anything.

### Fixed

* __hhs_punch: Various bugfixes.
* __hhs_search_string: Fix ss with spaces inside search string when hl the string.
* Install/Uninstall script were not working properly.
* __hhs_git_branch_select: Fixed the branch change when remote branch was selected.
* __hhs_mselect: bugfixes and upgrade.
* Important fixes to __hhs_alias, __hhs_save, __hhs_aliases, __hhs_paths and __hhs_command regarding the result arrays.
