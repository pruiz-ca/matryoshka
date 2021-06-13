#!/bin/bash
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    valgrind-docker.sh                                 :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: pruiz-ca <pruiz-ca@student.42madrid.co>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/06/13 17:41:00 by pruiz-ca          #+#    #+#              #
#    Updated: 2021/06/13 17:41:00 by pruiz-ca         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

source ~/.zshrc

if [[ "$(docker images -q $(whoami)/valgrind 2> /dev/null)" == "" ]]; then
	cd ~/.valgrind
	docker build -t $(whoami)/valgrind .
	cd $OLDPWD
fi

if [ ! "$(docker ps -q -f name=$(whoami)-valgrind)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=$(whoami)-valgrind)" ]; then
        docker rm $(whoami)-valgrind
    fi
    docker run -d -it -v `pwd`:/valgrind/ --name $USER-valgrind $(whoami)/valgrind
fi

docker exec -it $USER-valgrind zsh
