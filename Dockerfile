FROM ubuntu:latest
LABEL description="Valgrind"

ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install git-core -y
RUN apt-get install build-essential wget cmake valgrind clang vim -y
RUN apt-get install gcc make xorg libxext-dev libbsd-dev libreadline-dev -y
RUN apt-get install zsh zsh-autosuggestions zsh-syntax-highlighting -y

RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)" -- \
    -t https://github.com/denysdovhan/spaceship-prompt \
    -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
    -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
    -p git \
    -p ssh-agent \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions
RUN apt remove upower -y

WORKDIR /valgrind

# FROM alpine:latest
# LABEL description="Valgrind"

# ENV TZ=Europe/Madrid
# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# RUN apk update && apk upgrade && apk add --update --no-cache \
# 	zsh \
# 	zsh-autosuggestions \
# 	zsh-syntax-highlighting \
# 	zsh-vcs \
# 	bind-tools \
# 	alpine-sdk \
# 	cmake \
# 	clang \
# 	make \
# 	libxext-dev \
# 	libbsd-dev \
# 	readline-dev \
# 	valgrind \
# 	vim

# RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)" -- \
#     -t https://github.com/denysdovhan/spaceship-prompt \
#     -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
#     -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
#     -p ssh-agent \
#     -p https://github.com/zsh-users/zsh-autosuggestions \
#     -p https://github.com/zsh-users/zsh-completions

# WORKDIR /valgrind
