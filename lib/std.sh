#!/bin/bash
# WARNING! This file should not be executed directly.
#
# Standard library containing common functions and global variables.
################################################################################

#
# GLOBAL VARIABLES
#

[ -z "${_SELF-}" ]    && declare -g _SELF="Undefined"
[ -z "${_VERSION-}" ] && declare -g _VERSION="0.0.0"
[ -z "${_AUTHOR-}" ]  && declare -g _AUTHOR="John Doe"
[ -z "${_CALLER-}" ]  && declare -g _CALLER="$0"

# 16 Colors palette
# Reminder:
#     0 - normal
#     1 - bold
#     4 - underscore
declare -rg _COLOR_BLACK="\033[00;30m"
declare -rg _COLOR_RED="\033[00;31m"
declare -rg _COLOR_GREEN="\033[00;32m"
declare -rg _COLOR_BROWN="\033[00;33m"
declare -rg _COLOR_BLUE="\033[00;34m"
declare -rg _COLOR_PURPLE="\033[00;35m"
declare -rg _COLOR_CYAN="\033[00;36m"
declare -rg _COLOR_LIGHT_GRAY="\033[00;37m"

declare -rg _COLOR_BLACK_BOLD="\033[01;30m"
declare -rg _COLOR_LIGHT_RED="\033[01;31m"
declare -rg _COLOR_LIGHT_GREEN="\033[01;32m"
declare -rg _COLOR_YELLOW="\033[01;33m"
declare -rg _COLOR_LIGHT_BLUE="\033[01;34m"
declare -rg _COLOR_LIGHT_PURPLE="\033[01;35m"
declare -rg _COLOR_LIGHT_CYAN="\033[01;36m"
declare -rg _COLOR_WHITE="\033[01;37m"

declare -rg _COLOR_RESET="\033[0m"

#
# LOGGING FUNCTIONS
#

std::error() {
    echo -e "${_COLOR_PURPLE}${_SELF}${_COLOR_RESET} ${_COLOR_CYAN}[$(date +'%Y-%m-%dT%H:%M:%S%z')]${_COLOR_RESET} ${_COLOR_RED}ERROR${_COLOR_RESET}: $*" >&2
}

std::info() {
    echo -e "${_COLOR_PURPLE}${_SELF}${_COLOR_RESET} ${_COLOR_CYAN}[$(date +'%Y-%m-%dT%H:%M:%S%z')]${_COLOR_RESET} ${_COLOR_GREEN}INFO${_COLOR_RESET}: $*"
}

std::warning() {
    echo -e "${_COLOR_PURPLE}${_SELF}${_COLOR_RESET} ${_COLOR_CYAN}[$(date +'%Y-%m-%dT%H:%M:%S%z')]${_COLOR_RESET} ${_COLOR_YELLOW}WARNING${_COLOR_RESET}: $*" >&2
}
