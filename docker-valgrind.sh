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

docker ps -q &> /dev/null || sh -c "$(curl -fsSL https://raw.githubusercontent.com/alexandregv/42toolbox/master/init_docker.sh)"

if [[ "$(docker images -q valgrind-img 2> /dev/null)" == "" ]]; then
	cd ~/.valgrind
	docker build -t valgrind-img .
	cd $OLDPWD
fi

if [ ! "$(docker ps -q -f name=valgrind42)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=valgrind42)" ]; then
        docker rm valgrind42
    fi
    docker run -d -it -v $PWD:/valgrind/ --name valgrind42 valgrind-img
fi

docker exec -it valgrind42 zsh
