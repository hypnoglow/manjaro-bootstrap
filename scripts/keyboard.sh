#!/bin/bash
# WARNING! This file should not be executed directly.
#
# Keyboard setup
################################################################################

keyboard::set() {
    if ! keyboard::need; then
        return
    fi

    std::info "Set keyboard layout"
    # See more at https://wiki.archlinux.org/index.php/Keyboard_configuration_in_Xorg
    localectl set-x11-keymap us,ru  pc105 , grp:shift_caps_switch,grp_led:caps
    # Double -option -option is not error. See `man setxkbmap`
    setxkbmap -model pc105 -layout us,ru -option -option grp:shift_caps_switch,grp_led:caps
}

keyboard::need() {
    # Remove junk in /etc/X11/xorg.conf.d/90-mhwd.conf
    local mhwd_file="/etc/X11/xorg.conf.d/90-mhwd.conf"
    if [ "$(grep -c "Section \"InputClass\"" ${mhwd_file})" = "1" ]
    then
        local grepFrom=$(grep -n "Section \"InputClass\"" /etc/X11/xorg.conf.d/90-mhwd.conf)
        local from=${grepFrom%*:*}
        local grepTo=$(cat /etc/X11/xorg.conf.d/90-mhwd.conf | grep -n "EndSection" | tail -n1)
        local to=${grepTo%*:*}
        sudo mv "${mhwd_file}" "${mhwd_file}.bak"
        sed "${from},${to}d" "${mhwd_file}.bak" | sudo tee "${mhwd_file}" > /dev/null
    fi

    #if localectl status | grep -q "X11 Layout: us,ru"
    if setxkbmap -query | grep -P -q "^model:(\s*)pc105$" && \
       setxkbmap -query | grep -P -q "^layout:(\s*)us,ru$" && \
       setxkbmap -query | grep -P -q "^options:(\s*)grp:shift_caps_switch,grp_led:caps$"
    then
        return 1
    fi

    std::info "Current keyboard layout:"
    setxkbmap -query
    return 0
}
