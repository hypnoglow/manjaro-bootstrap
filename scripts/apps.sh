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

    echo "Installing node.js-n"
    git clone git@github.com:tj/n.git ${HOME}/sources/tj/n
    cd ${HOME}/sources/tj/n
    PREFIX=${HOME}/apps/n make install
}

apps::mongodb() {
    if [ -d "${HOME}/apps/mongodb-linux-x86_64-3.2.4/" ]; then
        return 0
    fi

    if ! ask::interactive "Install MongoDB 3.2.4 ?"; then
         return 0
    fi

    echo "Installing MongoDB 3.2.4"
    cd Downloads
    wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.2.4.tgz
    tar xzf mongodb-linux-x86_64-3.2.4.tgz
    mv mongodb-linux-x86_64-3.2.4 ~/apps/
    ln -s ~/apps/mongodb-linux-x86_64-3.2.4/bin/mongod ~/apps/bin/mongod
    ln -s ~/apps/mongodb-linux-x86_64-3.2.4/bin/mongo ~/apps/bin/mongo
}

apps::phpstorm() {
    if [ -x "$(which phpstorm 2>/dev/null)" ]; then
        return 0
    fi

    if ! ask::interactive "Install PhpStorm 10.0.3 ?"; then
         return 0
    fi

    cd Downloads
    wget http://download.jetbrains.com/webide/PhpStorm-10.0.3.tar.gz
    tar xzf PhpStorm-10.0.3.tar.gz
    mv PhpStorm-10.0.3 ~/apps/
    ln -s ~/apps/PhpStorm-10.0.3/bin/phpstorm.sh ~/apps/bin/phpstorm
}
