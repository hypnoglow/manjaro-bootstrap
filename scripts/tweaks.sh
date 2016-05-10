#!/bin/bash
# WARNING! This file should not be executed directly.
#
# Various system tweaks
################################################################################

tweaks::increase_inotify() {
    local conf="/etc/sysctl.d/99-sysctl.conf"

    if grep -q fs.inotify.max_user_watches ${conf}; then
        return
    fi

    std::info "Increasing inotify..."
    echo -e "# Increase inofity so apps (like dropbox and phpstorm) can watch tons of files (#hypnoglow)" | sudo tee -a ${conf}
    echo -e "fs.inotify.max_user_watches=131072" | sudo tee -a ${conf}
    sudo sysctl --system
    std::info "..ok"
}

tweaks::switch_to_zsh() {
    local zsh="/usr/bin/zsh"
    if [ "$(getent passwd ${USER} | cut -d: -f7)" != "${zsh}" ]; then
        ask::interactive "Change shell to zsh?" && chsh -s "${zsh}"
    fi
}

tweaks::gtk_themes() {
    ln -sfnv /usr/share/themes/Palemoon/Vertex-Maia-Dark/chrome "$(find "${HOME}/.moonchild productions/pale moon/" -type d -name *.default)/chrome"
    ln -sfnv /usr/share/themes/Firefox/Vertex-Maia-Dark/chrome "$(find "${HOME}/.mozilla/firefox/" -type d -name *.default)/chrome"
}
