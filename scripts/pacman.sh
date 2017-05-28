#!/bin/bash
# WARNING! This file should not be executed directly.
#
# Pacman utility scripts
################################################################################

pacman::set_color() {
    if ! grep -q ^#Color /etc/pacman.conf
    then
        return
    fi

    std::info "Set pacman color"
    cat /etc/pacman.conf | sed s/"#Color"/"Color"/ | sudo tee /etc/pacman.conf > /dev/null
}

pacman::update_keys() {
    std::info "Update pacman keys"
    sudo pacman-key --init
    sudo pacman-key --populate archlinux
    sudo pacman-key --populate manjaro
    sudo pacman-key --refresh-keys
}

pacman::update_mirrors() {
    std::info "Generate pacman mirrors"
    sudo pacman-mirrors -g
}

pacman::update_system() {
    # pacman returns 1 when no packages are outdated; 0 when updates.
    # yaourt returns 1 when no packages are outdated; 0 when updates.

    std::info "Sync pacman database..."
    sudo pacman -Sy

    std::info "Check manjaro packages..."
    if pacman -Qu && ask::interactive "Do a system update?"; then
        sudo pacman -Su --noconfirm
    fi

    std::info "Check AUR packages..."
    if yaourt -Qua && ask::interactive "Update AUR packages?"; then
        yaourt -Su --aur --noconfirm
    fi
}
