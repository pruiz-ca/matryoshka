#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;36m'
NOCOLOR='\033[0m'

INSTALL_PATH=${INSTALL_PATH:-~/.matryoshka}
REPO=${REPO:-pruiz-ca/Matryoshka}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-installfix}

# INSTALL_PATH=~/.matryoshka
# REPO=pruiz-ca/matryoshka
# REMOTE=https://github.com/$REPO.git
# BRANCH=installfix

function error() {
	echo -e $RED$1$NOCOLOR
	exit 1
}

function check_git_is_installed() {
	command -v git > /dev/null 2>&1 || error "git is not installed :(("
}

function clone_repository() {
	rm -rf ~/.matryoshka
	git clone "$REMOTE" "$INSTALL_PATH" > /dev/null 2>&1 || error "> git clone of matryoshka repo failed :("
	echo -en $NOCOLOR
}

function append_aliases() {
	alias_matryoshka="alias matryoshka='"$INSTALL_PATH/matryoshka.sh""\'
	sed -i _bak "/matryoshka.sh/d" ~/.zshrc
	echo "$alias_matryoshka" >> ~/.zshrc
}

function create_config_file() {
	touch ~/.matryoshkarc
	cat << EOF > ~/.matryoshkarc
#####
# ADDITIONAL PACKAGES TO INSTALL - Space separated values
# Preinstalled: nano zsh ohmyzsh python3 curl ncdu git
#
# Example: PACKAGES="vim make clang g++ valgrind docker docker-compose"
#####
PACKAGES="bash vim"


# Change to "true" if you need norminette to be installed
NORMINETTE=false

#####
# PARTITION SIZE - in MB
# - PART_42IMAC -> partition size to be used if matryoshka is run on a 42 iMac
# - PART_ELSEWHERE -> partition size to be used in other computers
#####
SIZE_42IMAC=20480
SIZE_ELSEWHERE=8192
EOF
}

function success_message() {
	echo -e $GREEN"Matryoshka has been installed!"
	echo -e $BLUE"Now reload your terminal to apply changes and run$YELLOW matryoshka$BLUE. Cheers!"
	echo -en $NOCOLOR
}

main() {
	check_git_is_installed
	clone_repository
	append_aliases
	create_config_file
	success_message
}

main "$@"
