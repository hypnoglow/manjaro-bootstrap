#!/bin/bash
# WARNING! This file should not be executed directly.
#
################################################################################

ask::ask() {
    if [ -z "$1" ]; then
        echo "Internal error: ask() called without question" >&2
        exit 1
    fi

    local question="$1"
    local answer

    echo -n "$question [y/N]: "
    read -n 1 answer
    echo
    if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
        return 1
    fi

    return 0
}

# If called in non-interactive mode, always return true.
# Else return 0 or 1 based on answer.
ask::interactive() {
    if [ "${interactive-}" = false ]; then
        return 0
    fi

    ask::ask "$1"
    return "$?"
}
