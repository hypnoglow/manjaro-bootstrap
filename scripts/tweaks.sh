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

tweaks::setup_lightdm_theme() {
    if ! pacman -Qs lightdm-webkit-theme-material-git &>/dev/null ; then
        std::warning "Package 'lightdm-webkit-theme-material-git' not found: cannot apply lightdm theme tweaks"
        return 0
    fi

    if grep -Fxq "greeter-session=lightdm-gtk-greeter" /etc/lightdm/lightdm.conf; then
        std::info "Tweak LightDM greeter"

        cat /etc/lightdm/lightdm.conf | sed s/"greeter-session=lightdm-gtk-greeter"/"greeter-session=lightdm-webkit2-greeter"/ | sudo tee /etc/lightdm/lightdm.conf > /dev/null
        cat /etc/lightdm/lightdm-webkit2-greeter.conf | sed s/"webkit-theme = antergos"/"webkit-theme = material"/ | sudo tee /etc/lightdm/lightdm-webkit2-greeter.conf > /dev/null
    fi

    if [ ! -f "/var/lib/AccountsService/icons/${USER}" ] ; then
        cd /tmp
        wget -q https://avatars0.githubusercontent.com/u/4853075 -O avatar.jpg
        sudo mv avatar.jpg /var/lib/AccountsService/icons/${USER}
    fi

    if ! grep -q "Icon=" /var/lib/AccountsService/users/hypnoglow ; then
        echo "Icon=/var/lib/AccountsService/icons/${USER}" | sudo tee -a /var/lib/AccountsService/users/hypnoglow 1>/dev/null
    fi
}
