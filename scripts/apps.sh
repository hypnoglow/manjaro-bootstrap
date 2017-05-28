#!/bin/bash
# WARNING! This file should not be executed directly.
#
###############################################################################

apps::nodejs-n() {
    if [ -x "$(which n 2> /dev/null)" ]; then
		return 0
	fi

    if ! ask::interactive "Install node.js-n?"; then
        return 0
    fi

    std::info "Install node.js-n"
    git clone https://github.com/tj/n ${HOME}/sources/tj/n
    cd ${HOME}/sources/tj/n
    PREFIX=${HOME}/apps/n make install

    # Install latest node and npm packages
    std::info "Install latest Node.js and global npm packages"
    export N_PREFIX="${HOME}/apps/n"
    export PATH="$PATH:$N_PREFIX/bin"
    n latest
}

apps::npm-global-packages() {
    if [ ! -x "$(which npm 2> /dev/null)" ]; then
        return 0
    fi

    local packages
    packages=(
        karma-cli
        nodemon
        create-react-app
    )

    for package in "${packages[@]}"; do
        if [ -e "${HOME}/apps/n/lib/node_modules/${package}" ]; then
            continue;
        fi

        std::info "Installing \"${package}\" with \"npm install -g\" ..."
        npm install -g "${package}"
    done
}

apps::mongodb() {
    local version="3.4.1"
    if [ -d "${HOME}/apps/mongodb-linux-x86_64-${version}/" ]; then
        return 0
    fi

    if ! ask::interactive "Install MongoDB ${version} ?"; then
         return 0
    fi

    std::info "Installing MongoDB ${version}"
    cd ${HOME}/Downloads
    wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-${version}.tgz
    tar xzf mongodb-linux-x86_64-${version}.tgz
    mv mongodb-linux-x86_64-${version} ~/apps/
    ln -s ~/apps/mongodb-linux-x86_64-${version}/bin/mongod ~/apps/bin/mongod
    ln -s ~/apps/mongodb-linux-x86_64-${version}/bin/mongo ~/apps/bin/mongo
}

apps::realsync() {
    if [ -x "$(which realsync 2>/dev/null)" ]; then
        return 0
    fi

    if ! ask::interactive "Install realsync ?"; then
         return 0
    fi

    git clone https://github.com/DmitryKoterov/dklab_realsync.git /tmp/realsync
    sudo mkdir -p /opt/dklab/
    sudo mv /tmp/realsync /opt/dklab
    sudo ln -s /opt/dklab/realsync/realsync /usr/local/bin/realsync
}

apps::phpstorm() {
    if [ -x "$(which phpstorm 2>/dev/null)" ]; then
        return 0
    fi

    local version="2017.1.4"

    if ! ask::interactive "Install PhpStorm ${version} ?"; then
         return 0
    fi

    ts=$(date +"%s")
    dir="/tmp/phpstorm-$ts"
    mkdir $dir
    cd ${HOME}/Downloads
    wget https://download.jetbrains.com/webide/PhpStorm-${version}.tar.gz
    tar xzf PhpStorm-${version}.tar.gz -C $dir
    phpstorm_dir="$dir/$(ls $dir)"
    mv ${phpstorm_dir}  ~/apps/phpstorm-${version}
    ln -sf ~/apps/phpstorm-${version}/bin/phpstorm.sh ~/apps/bin/phpstorm
}

apps::gogland() {
    if [ -x "$(which gogland 2>/dev/null)" ]; then
        return 0
    fi

    local version="171.4424.55"

    if ! ask::interactive "Install Gogland ${version} ?"; then
         return 0
    fi

    ts=$(date +"%s")
    dir="/tmp/gogland-$ts"
    mkdir $dir
    cd ${HOME}/Downloads
    wget https://download.jetbrains.com/go/gogland-${version}.tar.gz
    tar xzf gogland-${version}.tar.gz -C $dir
    gogland_dir="$dir/$(ls $dir)"
    mv ${gogland_dir}  ~/apps/gogland-${version}
    ln -sf ~/apps/gogland-${version}/bin/gogland.sh ~/apps/bin/gogland
}

apps::php56() {
    if [ -x "$(which php56 2>/dev/null)" ]; then
        return 0
    fi

    if ! ask::interactive "Install PHP 5.6 ?"; then
         return 0
    fi

    cd /tmp
    wget http://at1.php.net/get/php-5.6.21.tar.bz2/from/this/mirror -O php-5.6.21.tar.bz2
    tar xjf php-5.6.21.tar.bz2
    cd php-5.6.21
    ./configure --enable-fpm --with-mysql --prefix=${HOME}/apps/php-5.6.21
    make install

    cp /tmp/php-5.6.21/php.ini-development ~/apps/php-5.6.21/lib/php.ini

    ln -s ~/apps/php-5.6.21/bin/php ~/apps/bin/php56
}

apps::go-apps() {
    GOPATH=${GOPATH:-$HOME/go}
    export GOPATH

    local apps
    apps=(
        github.com/hypnoglow/gomuche
        github.com/hypnoglow/i3x
        github.com/alecthomas/gometalinter
        github.com/sqs/goreturns
        github.com/ivpusic/rerun
        github.com/msoap/go-carpet
    )

    for app in "${apps[@]}"; do
        name="${app##*/}"
        if [ -d "${GOPATH}/src/${app}" ] && [ -n "$(which $name 2>/dev/null)" ]; then
            continue;
        fi

        std::info "Installing \"${app}\" with go get..."
        go get -v -u "$app"

        # a bit dirty
        if [ "$name" = "gometalinter" ]; then
            $GOPATH/bin/gometalinter --install
        fi
    done

    return 0

    go get -u github.com/kardianos/govendor
}

apps::vagrant() {
    if [ ! -x "$(which vagrant 2>/dev/null)" ]; then
        return 0
    fi

    if vagrant plugin list | grep -q vagrant-share ; then
        return 0
    fi

    std::info "Install vagrant plugin: vagrant-share"
    vagrant plugin install vagrant-share
}
