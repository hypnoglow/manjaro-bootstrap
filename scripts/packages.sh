#!/bin/bash
# WARNING! This file should not be executed directly.
#
# Installs custom packages.
################################################################################

packages::install_all() {
    local profile="$1"
    if [ -z "${profile}" ]; then
        std::warning >&2 "Cannot install custom packages: profile is not specified."
        return 1
    fi

    #disable globbing because of special characters in packages file
    set -f
    local packages_file="${self_dir}/packages.list"
    local packages=$( cat "${packages_file}" | egrep -v "^#")
    local line

    while IFS='' read -r line || [[ -n "${line}" ]]; do
        if [[ "${line}" =~ ^# || -z "${line}" ]]; then
            continue;
        fi

        # parse line
        local package_data=(${line})
        local package_profiles
        local package_name
        local package_src
        if [ -z "${package_data[1]-}" ]; then
            package_profiles="*"
            package_name="${package_data[0]}"
        else
            package_profiles="${package_data[0]}"
            package_name="${package_data[1]}"
            package_src="${package_data[2]-}"
        fi

        # install
        if packages::need_to_install "${package_profiles}" "${package_name}" "${profile}"; then
            packages::install_one "${package_name}" "${package_src}"
        fi

    done < "${packages_file}"
}

packages::install_one() {
    local package="$1"
    local src="$2"
    #echo "install ${package} from ${src}"

    std::info "Install '${package}'"
    if [ "${src}" = "aur" ]; then
        yaourt -S "${package}" --noconfirm
    else
        sudo pacman -S "${package}" --noconfirm
    fi

    if [ $? -ne 0 ]; then
        std::error "Failed to install '${package}'" >&2
        exit 1
    fi
}

packages::need_to_install() {
    local package_profiles="$1"
    local package_name="$2"
    local user_profile="$3"

    if pacman -Q ${package_name} &>/dev/null ; then
        std::info "'${package_name}' is installed"
        return 1
    fi

    if [ "${package_profiles}" = "*" ]; then
        return 0
    fi

    profilesArray=(${package_profiles//,/ })

    local profile
    local install=false
    for profile in ${profilesArray[*]}; do
        if [[ "${profile}" =~ ^\! ]]; then
            # Inverted profile
            profile=${profile#!*}
            if [ "${user_profile}" = "${profile}" ]; then
                continue
            fi

            install=true
            break
        else
            # Normal profile
            if [ "${user_profile}" != "${profile}" ]; then
                continue
            fi

            install=true
            break
        fi
    done

    if ${install} ; then
        std::info "Install package ${package_name}"
        return 0
    fi

    std::info "Skip package ${package_name}"
    return 1
}
