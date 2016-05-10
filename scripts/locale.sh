#!/bin/bash
# WARNING! This file should not be executed directly.
#
# Locale setup
################################################################################

locale::set() {
    if grep -q "#ru_RU.UTF-8 UTF-8" /etc/locale.gen
    then
        std::info "Install locale"
        # https://wiki.archlinux.org/index.php/locale
        cat /etc/locale.gen | sed s/"#ru_RU.UTF-8 UTF-8"/"ru_RU.UTF-8 UTF-8"/ | sudo tee /etc/locale.gen > /dev/null
        sudo locale-gen
        # Changes will take effect for new session at login
        echo -e "LANG=en_US.UTF-8\nLC_TIME=ru_RU.UTF-8\nLC_NUMERIC=ru_RU.UTF-8" | sudo tee /etc/locale.conf > /dev/null
    fi
}
