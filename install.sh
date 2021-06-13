#!/bin/bash
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    install.sh                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: pruiz-ca <pruiz-ca@student.42madrid.co>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/06/13 17:48:48 by pruiz-ca          #+#    #+#              #
#    Updated: 2021/06/13 17:48:48 by pruiz-ca         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

INSTALL_PATH=${INSTALL_PATH:-~/.valgrind}
REPO=${REPO:-pruiz-ca/Valgrind42}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-main}

command_exists() {
command -v "$@" >/dev/null 2>&1
}

append_aliases(){
LINE="alias valgrind='~/.valgrind/docker-valgrind.sh'"
grep -qF -- "$LINE" "/Users/$(whoami)/.zshrc" || echo "$LINE" >> "/Users/$(whoami)/.zshrc"

LINE="alias dockerclean='~/.valgrind/docker-clean.sh'"
grep -qF -- "$LINE" "/Users/$(whoami)/.zshrc" || echo "$LINE" >> "/Users/$(whoami)/.zshrc"
}

setup_color() {
if [ -t 1 ]; then
RED=$(printf '\033[31m')
GREEN=$(printf '\033[32m')
YELLOW=$(printf '\033[33m')
BLUE=$(printf '\033[34m')
BOLD=$(printf '\033[1m')
RESET=$(printf '\033[m')
else
RED=""
GREEN=""
YELLOW=""
BLUE=""
BOLD=""
RESET=""
fi
}

setup_valgrind42() {
echo "${BLUE}Installing Valgrind42...${RESET}"

command_exists git || {
fmt_error "git is not installed"
exit 1
}

git clone -c core.eol=lf -c core.autocrlf=false \
-c fsck.zeroPaddedFilemode=ignore \
-c fetch.fsck.zeroPaddedFilemode=ignore \
-c receive.fsck.zeroPaddedFilemode=ignore \
--depth=1 --branch "$BRANCH" "$REMOTE" "$INSTALL_PATH" || {
fmt_error "git clone of valgrind42 repo failed"
exit 1
}
echo
}

main()
{
setup_color
setup_valgrind42
append_aliases

printf %s "$GREEN"
cat <<'EOF'
Valgrind42 has been installed!
Now you can run "valgrind" in the directory you want to use as root to start valgrind.
You can also delete all docker related files with "dockerclean".
Cheers!
EOF
printf %s "$RESET"
}

main "$@"

