#!/usr/bin/env bash
# shellcheck disable=
#  Script: bash_aliasdef.bash
# Purpose: This file is used to customize your prompt alias shortcuts
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>

# -----------------------------------------------------------------------------------
# Function aliases shortcuts

# General
__hhs_alias has='__hhs_has'
__hhs_alias hl='__hhs_highlight'
__hhs_alias hist='__hhs_history'
__hhs_alias del-tree='__hhs_del-tree'
__hhs_alias jp='__hhs_json-print'
__hhs_alias ip-info='__hhs_ip-info'
__hhs_alias ip-resolve='__hhs_ip-resolve'
__hhs_alias ip-lookup='__hhs_ip-lookup'
__hhs_alias port-check='__hhs_port-check'
__hhs_alias envs='__hhs_envs'
__hhs_alias paths='__hhs_paths'
__hhs_alias ver='__hhs_version'
__hhs_alias tc='__hhs_toolcheck'
__hhs_alias tl='__hhs_tailor'
__hhs_alias tools='__hhs_tools'
__hhs_alias mselect='__hhs_mselect'
__hhs_alias aa='__hhs_aliases'
__hhs_alias save='__hhs_save-dir'
__hhs_alias load='__hhs_load-dir'
__hhs_alias cmd='__hhs_command'
__hhs_alias punch='__hhs_punch'
__hhs_alias plist='__hhs_process_list'
__hhs_alias godir='__hhs_go-dir'
__hhs_alias sysinfo='__hhs_sysinfo'
__hhs_alias parts='__hhs_partitions'
__hhs_alias hhu='__hhs_update'
__hhs_alias cse='__hhs_clean_escapes'

# Python based shortcuts
if __hhs_has "python"; then
  __hhs_alias sf='__hhs_search-file'
  __hhs_alias sd='__hhs_search-dir'
  __hhs_alias ss='__hhs_search-string'
fi

# GPG shorctus
if __hhs_has "gpg"; then
  __hhs_alias encrypt='__hhs_encrypt_file'
  __hhs_alias decrypt='__hhs_decrypt_file'
fi

# Git shortcuts
if __hhs_has "git"; then
  __hhs_alias git-='__hhs_git-'
  __hhs_alias gs='__hhs_git_status'
  __hhs_alias gf='__hhs_git_fetch'
  __hhs_alias gh='__hhs_git_history'
  __hhs_alias gb='__hhs_git_branch'
  __hhs_alias gd='__hhs_git_diff'
  __hhs_alias gp='__hhs_git_pull'
  __hhs_alias gl='__hhs_git_log'
  __hhs_alias gco='__hhs_git_checkout'
  __hhs_alias gta='__hhs_git_add'
  __hhs_alias gcm='__hhs_git_commit'
  __hhs_alias gca='__hhs_git_amend'
  __hhs_alias gba='__hhs_git_branch_all'
  __hhs_alias gsa='__hhs_git_status_all'
  __hhs_alias gprb='__hhs_git_pull_rebase'
  __hhs_alias gtps='__hhs_git_push'
  __hhs_alias gshow='__hhs_git_show'
  __hhs_alias gdshow='__hhs_git_diff_show'
  __hhs_alias gdt='__hhs_git_difftool'
fi

# Gradle shortcuts
if __hhs_has "gradle"; then
  __hhs_alias gw='__hhs_gradlew'
  __hhs_alias gwb='__hhs_gradle_build'
  __hhs_alias gwr='__hhs_gradle_run'
  __hhs_alias gwtt='__hhs_gradle_test'
  __hhs_alias gwi='__hhs_gradle_init'
  __hhs_alias gwq='__hhs_gradle_quiet'
  __hhs_alias gww='__hhs_gradle_wrapper'
  __hhs_alias gwt='__hhs_gradle_tasks'
  __hhs_alias gwp='__hhs_gradle_projects'
fi

# Docker shortcuts
if __hhs_has "docker" && docker info &>/dev/null; then
  __hhs_alias dki='__hhs_docker_images'
  __hhs_alias dks='__hhs_docker_service'
  __hhs_alias dkl='__hhs_docker_logs'
  __hhs_alias dke='__hhs_docker_exec'
  __hhs_alias dku='__hhs_docker_up'
  __hhs_alias dkd='__hhs_docker_down'
  __hhs_alias dkce='__hhs_docker_compose_exec'
  __hhs_alias dkrm='__hhs_docker_remove'
  __hhs_alias dkps='__hhs_docker_ps'
  __hhs_alias dktl='__hhs_docker_tail_logs'
  __hhs_alias dkls='__hhs_docker_ls'
  __hhs_alias dkrmv='__hhs_docker_remove_volumes'
  __hhs_alias dkrmi='__hhs_docker_remove_image'
  __hhs_alias dkpid='__hhs_docker_pidof'
  __hhs_alias dktop='__hhs_docker_top'
fi