#!/usr/bin/env bash

function setRestrictedMode () {
    set -o nounset                  # make using undefined variables throw an error
    set -o errexit                  # exit immediately if any command returns non-0
    set -o pipefail                 # exit from pipe if any command within fails
    set -o errtrace                 # subshells should inherit error handlers/traps
}

# Some places are automatically generated or fetched from 3rd party and hard to
# control.
function unsetRestrictedMode {
    set +o nounset
    set +o errexit
    set +o pipefail
    set +o errtrace
}

# [Source][@/BashutilsUtilBasesh]|[Zotero][z@/BashutilsUtilBasesh]
# Basic utils and setup used by all the other scripts

### Bash Environment Setup
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
# set -o xtrace                 # print every command before executing (for debugging)
# setRestrictedMode
# shopt -s dotglob                # make * globs also match .hidden files
# shopt -s inherit_errexit        # make subshells inherit errexit behavior
# IFS=$'\n'                       # set array separator to newline to avoid word splitting bugs
# trap 'log_quit SIGINT' SIGINT
# trap 'log_quit SIGPIPE' SIGPIPE
# trap 'log_quit SIGQUIT' SIGQUIT
# trap 'log_quit SIGTSTP' SIGTSTP
# trap 'log_quit TIMEOUT' SIGALRM
# trap 'log_quit SIGABRT' SIGABRT
# FIX: When exiting ranger with `q`: '-bash: cd: null directory'
# trap 'log_quit $? "${BASH_SOURCE//$PWD/.}:${LINENO} ${FUNCNAME:-}($(IFS=" "; echo "$*"))"' ERR

# QUESTION: Didn't understand purpose of it. It seems related to "strict
# mode"...
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
ROOT_PID=$$
PARENT_PID=$PPID

# Was causing the exact same errors with `log_quit` described in [GitHub
# issue](https://github.com/pirate/bash-utils/issues/2)
# get input/output redirection state
# [[ ! -t 0 ]]; IS_STDIN_TTY="${?}"
# [[ ! -t 1 ]]; IS_STDOUT_TTY="${?}"
# [[ ! -t 2 ]]; IS_STDERR_TTY="${?}"
# [[ ! "$IS_STDIN_TTY$IS_STDOUT_TTY$IS_STDERR_TTY" == "111" ]]; IS_TTY="${?}"

### General Helpers
# # Modules and dependencies
# STYLE: Don't use these for automatic dependency management - utilize Python
# & Ansible & Nix instead. Use these only to enforce imports between bash
# scripts. As for command dependencies: it's ok to check that some command
# exists but don't manage (install or update) it automatically inside bash.

# Check to make sure the given functions are loaded
function IMPORT {
    local -a IMPORTS=("$@")
    local FUNC
    local PATH


    for PATH in ${IMPORTS[*]}; do
        IFS='.'
        for step in $PATH; do
            if [[ -d "$step" ]]; then
                cd "$step"
            elif [[ -f "$step" ]]; then
                source "$step"
                break
            fi
        done
        FUNC="${PATH[-1]}"
        IFS=$'\n'

        if [[ "$(type -t "$FUNC")" != "function" ]]; then
            echo "[X] Missing required function $FUNC (is the import path $PATH correct?)" >&2
            exit 4
        fi
    done
}

function REQUIRES_FUNCS {
    for FUNC in "$@"; do
        if [[ "$(type -t "$FUNC")" != "function" ]]; then
            echo "[X] Missing required function $FUNC (is the import path $PATH correct?)" >&2
            exit 4
        fi
    done
}

function REQUIRES_CMDS {
    for CMD in "$@"; do
        if ! command -v "$CMD" > /dev/null; then
            echo "[X] Missing required command $CMD (is it installed on this system and available in \$PATH?)" >&2
            exit 4
        fi
    done
}

function REQUIRES_VARS {
    for VAR in "$@"; do
        VALUE=${VAR:-}

        if [[ -z "${VALUE}" ]]; then
            echo "[X] Missing required variable $VAR (did you import all the required files in the right order?)" >&2
            exit 4
        fi
    done
}

function REQUIRES_CONFIG {
    for VAR in "$@"; do
        VALUE=${CONFIG[VAR]:-}

        if [[ -z "${VALUE}" ]]; then
            echo "[X] Missing required config variable $VAR (did you import all the required files in the right order?)" >&2
            exit 4
        fi
    done
}

# # Debugging.
function backtrace {
    local depth=${1:-#FUNCNAME[@]}

    for ((i=2; i<depth; i++)); do
        local func="${FUNCNAME[$i]}"
        local line="${BASH_LINENO[$((i))]}"
        local src="${BASH_SOURCE[$((i))]}"
        printf '%*s' $i '' # indent
        echo "at: $func(), $src, line $line"
    done
}

# References:
# [@/BashutilsUtilBasesh]: <https://github.com/pirate/bash-utils/blob/ac2b8dabc3b7a81d51b870aaf162ef5f38676d1f/util/base.sh> 'Bash-Utils/Util/Base.Sh at Master · Pirate/Bash-Utils'
# [z@/BashutilsUtilBasesh]: <zotero://select/items/@/BashutilsUtilBasesh> 'Select in Zotero: Bash-Utils/Util/Base.Sh at Master · Pirate/Bash-Utils'
