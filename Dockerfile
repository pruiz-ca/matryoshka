FROM ubuntu:latest
LABEL description="Valgrind"

ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y
RUN apt-get install -y \
    build-essential git-core wget curl \
    xorg libxext-dev libbsd-dev libreadline-dev libx11-dev \
    x11proto-core-dev libxt-dev \
    make cmake gcc clang-9 lldb llvm valgrind g++ as31 nasm  \
    vim emacs zsh zsh-autosuggestions zsh-syntax-highlighting \
    python3-pip python-pip ruby ruby-bundler ruby-dev \
    php-cli php-curl php-gd php-intl php-json \
    php-mbstring php-xml php-zip php-mysql php-pgsql \
    freeglut3 libncurses5-dev glmark2

RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)" -- \
    -t https://github.com/denysdovhan/spaceship-prompt \
    -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
    -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
    -p git \
    -p ssh-agent \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions
RUN apt remove upower -y

RUN python3 -m pip install --upgrade pip setuptools
RUN python3 -m pip install norminette

RUN git clone https://github.com/42Paris/42header.git
RUN 42header/set_header.sh

RUN git clone https://github.com/42Paris/minilibx-linux.git
RUN minilibx-linux/configure

COPY minilibx-linux/libmlx.a /usr/local/lib/
COPY minilibx-linux/mlx.h /usr/local/include/
COPY minilibx-linux/man/man3/mlx*.3 /usr/local/man/man3/

WORKDIR /valgrind
