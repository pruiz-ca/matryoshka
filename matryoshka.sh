#!/bin/bash
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    matryoshka.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: pruiz-ca <pruiz-ca@student.42madrid.co>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/06/14 18:42:03 by pruiz-ca          #+#    #+#              #
#    Updated: 2021/06/14 18:42:15 by pruiz-ca         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

if [ "$(docker images -q matryoshka-img 2> /dev/null)" == "" ]; then
	cd ~/.matryoshka
	docker build -t matryoshka-img .
	cd $OLDPWD
fi

if [ ! "$(docker ps -q -f name=matryoshka)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=matryoshka)" ]; then
        docker rm matryoshka
    fi
    docker run -d -it -v $PWD:/macos/ --name matryoshka matryoshka-img
fi

docker exec -it matryoshka zsh
