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
    if [ ! -f "/var/lib/AccountsService/icons/${USER}" ] ; then
        cd /tmp
        wget -q https://avatars0.githubusercontent.com/u/4853075 -O avatar.jpg
        sudo mv avatar.jpg /var/lib/AccountsService/icons/${USER}
    fi

    if ! grep -q "Icon=" /var/lib/AccountsService/users/hypnoglow ; then
        echo "Icon=/var/lib/AccountsService/icons/${USER}" | sudo tee -a /var/lib/AccountsService/users/hypnoglow 1>/dev/null
    fi

    if [ "${arg_profile}" != "desktop" ] && [ "${arg_profile}" != "job" ]; then
        return 0
    fi

    if ! pacman -Qs lightdm-webkit-theme-material-git &>/dev/null && \
       ! pacman -Qs lightdm-webkit-theme-aether &>/dev/null; then
        std::warning "LightDM webkit theme not found: cannot apply lightdm theme tweaks"
        return 0
    fi

    # webkit theme is installed, so switch to webkit2 greeter if need.

    if grep -Fxq "greeter-session=lightdm-gtk-greeter" /etc/lightdm/lightdm.conf; then
        std::info "Tweak LightDM greeter"
        cat /etc/lightdm/lightdm.conf | sed s/"greeter-session=lightdm-gtk-greeter"/"greeter-session=lightdm-webkit2-greeter"/ | sudo tee /etc/lightdm/lightdm.conf > /dev/null
    fi

    if grep -Fxq "#greeter-session=example-gtk-gnome" /etc/lightdm/lightdm.conf; then
        std::info "Tweak LightDM greeter"
        cat /etc/lightdm/lightdm.conf | sed s/"#greeter-session=example-gtk-gnome"/"greeter-session=lightdm-webkit2-greeter"/ | sudo tee /etc/lightdm/lightdm.conf > /dev/null
    fi

    # if theme is not set
    if grep -E "^webkit_theme\s*=\s*antergos" /etc/lightdm/lightdm-webkit2-greeter.conf; then
        if pacman -Qs lightdm-webkit-theme-aether &>/dev/null; then
            std::info "Set webkit theme \"aether\" for lightdm-webkit2-greeter"
            cat /etc/lightdm/lightdm-webkit2-greeter.conf | sed s/"^webkit_theme\s*=\s*antergos"/"webkit_theme = lightdm-webkit-theme-aether"/ | sudo tee /etc/lightdm/lightdm-webkit2-greeter.conf > /dev/null
        elif pacman -Qs lightdm-webkit-theme-material-git &>/dev/null; then
            std::info "Set webkit theme \"material\" for lightdm-webkit2-greeter"
            cat /etc/lightdm/lightdm-webkit2-greeter.conf | sed s/"webkit_theme\s*=\s*antergos"/"webkit_theme = material"/ | sudo tee /etc/lightdm/lightdm-webkit2-greeter.conf > /dev/null
        fi
    fi
}

tweaks::setup_docker() {
    if ! groups ${USER} | grep -q docker ; then
        sudo gpasswd --add ${USER} docker
    fi

    local filename="override.conf"

    if [ -f "/etc/systemd/system/docker.service.d/${filename}" ] ; then
        return 0
    fi

    std::info "Setup docker"
    sudo mkdir -p /etc/systemd/system/docker.service.d/
    sudo cp "${self_dir}/sources/etc/systemd/system/docker.service.d/${filename}" \
    "/etc/systemd/system/docker.service.d/${filename}"

    sudo systemctl daemon-reload
    sudo systemctl restart docker
}

tweaks::setup_virtualbox() {
    if [ ! -x "$(which vboxmanage 2>/dev/null)" ]; then
        return 0
    fi

    if [ -e "/etc/modules-load.d/vbox.conf" ]; then
        return 0
    fi

    std::info "Setup VirtualBox kernel modules autoload"
    sudo cp ${self_dir}/sources/etc/modules-load.d/vbox.conf \
    /etc/modules-load.d/vbox.conf

    # Load modules for current session
    sudo modprobe vboxnetadp
    sudo modprobe vboxnetflt
    sudo modprobe vboxpci
}

tweaks::disable_servises() {
    local -a services=(
    bluetooth.service
    ModemManager.service
    )

    for service in "${services[@]}" ; do
        if systemctl -q is-enabled ${service} ; then
            std::info "Disabling service ${service}"
            if systemctl -q is-active ${service} ; then
                sudo systemctl stop ${service}
            fi
            sudo systemctl disable ${service}
        fi
    done


}

tweaks::ngs_resolv() {
    if grep -q "cname.s in.ngs.ru" /etc/resolv.conf; then
        return 0
    fi

    # https://www.freebsd.org/cgi/man.cgi?query=resolvconf.conf
    std::info "Add NGS domains to resolv.conf"
    echo -e "#NGS\nsearch_domains=\"cname.s in.ngs.ru\"" | sudo tee -a /etc/resolvconf.conf 1>/dev/null
    sudo resolvconf -u

}

tweaks::default_web_browser() {
    if [ "$(xdg-settings check default-web-browser google-chrome.desktop)" = "no" ]; then
        std::info "Setting chrome as default browser"
        xdg-settings set default-web-browser google-chrome.desktop
    fi
}
