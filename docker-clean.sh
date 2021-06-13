#!/bin/bash
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

source ~/.zshrc

DOCKER_CONTAINERS	=		$(shell docker ps -a -q)
DOCKER_VOLUMES		=		$(shell docker volume ls -q)

ifneq ($(strip $(DOCKER_CONTAINERS)),)
	@docker rm $(DOCKER_CONTAINERS) -f
endif

ifneq ($(strip $(DOCKER_VOLUMES)),)
	docker volume rm $(DOCKER_VOLUMES)
endif

docker system prune -a -f
