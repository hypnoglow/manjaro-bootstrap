# manjaro-bootstrap

A simple script that brings Manjaro Linux system to a consistent state,
e.g. after a fresh installation.

## Bootstrapping

Clone this repo:

    git clone https://github.com/hypnoglow/manjaro-bootstrap.git
    cd manjaro-bootstrap

See usage info:

    ./bootstrap -h

There are several profiles available.
Choose one for your current system, then run:

    ./bootstrap <profile>

If you have any issues with pacman keys during a system update, run bootstrap with `-k` option.

## Your own bootstrap

Feel free to fork or copy this repo to create your own bootstrap script.
You can adjust profiles, packages and other stuff to your needs.

## Additional information

There is a [Vagrantfile](https://github.com/hypnoglow/manjaro-bootstrap/blob/master/Vagrantfile) in this repository. You can use it to test this boostrap and to see what it does without any changes to your current system.

## License

[MIT](https://github.com/hypnoglow/manjaro-bootstrap/blob/master/LICENCE)
