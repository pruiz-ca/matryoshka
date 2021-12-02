#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;36m'
NOCOLOR='\033[0m'

function error() {
	echo -e $RED$1$NOCOLOR
	exit 1
}

function check_vbox_is_installed() {
	command -v VBoxManage > /dev/null 2>&1 || error "Virtual Box is not installed :(("
}

function usage_help() {
	echo -e $BLUE"Usage:$YELLOW matryoshka <action>"
	echo -e $BLUE"<action> can be: run | stop | clean | update | reset | uninstall"$NOCOLOR
}

if [[ $0 == $BASH_SOURCE ]]; then
	check_vbox_is_installed
	if [[ -f ./scripts/$1.sh ]]; then
		./scripts/$1.sh
		exit 0
	fi
	usage_help
fi
