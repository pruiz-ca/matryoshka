#!/bin/sh
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    docker-clean.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: pruiz-ca <pruiz-ca@student.42madrid.co>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/06/13 17:41:12 by pruiz-ca          #+#    #+#              #
#    Updated: 2021/06/13 17:41:12 by pruiz-ca         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -a -q)
docker system prune -a -f
