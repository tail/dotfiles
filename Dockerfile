FROM ubuntu:24.04

ARG USERNAME=ubuntu

ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=bash
ENV TZ=Etc/UTC

RUN set -ex; \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get install --no-install-recommends -y \
        bash-completion \
        build-essential \
        clang \
        cmake \
        curl \
        direnv \
        dnsutils \
        dstat \
        git \
        gpg \
        gpg-agent \
        htop \
        httpie \
        iftop \
        iotop \
        iproute2 \
        iputils-ping \
        jq \
        netcat-openbsd \
        net-tools \
        perl \
        screen \
        strace \
        sudo \
        sysstat \
        tcpdump \
        telnet \
        tmux \
        tzdata \
        universal-ctags \
        vim \
        wget \
        whois \
        ; \
    :; \
    install -dm 755 /etc/apt/keyrings; \
    wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor \
        | tee /etc/apt/keyrings/mise-archive-keyring.gpg 1> /dev/null; \
    echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=amd64] https://mise.jdx.dev/deb stable main" \
        | tee /etc/apt/sources.list.d/mise.list ;\
    apt update; \
    apt install -y mise; \
    :; \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers; \
    rm -rf /var/lib/apt/lists/*

RUN useradd ${USERNAME} || true

COPY --chown=${USERNAME}:${USERNAME} . /home/${USERNAME}/dotfiles

USER ${USERNAME}

WORKDIR /home/${USERNAME}

SHELL ["/bin/bash", "-c"]

RUN set -ex; \
    mise use \
        fzf \
        go \
        java \
        neovim \
        node@lts \
        ripgrep \
        rust \
        uv \
        ; \
    :; \
    cd dotfiles; \
    ./install.sh; \
    source /home/${USERNAME}/.bashrc; \
    :; \
    uv tool install pynvim; \
    npm install -g yarn; \
    :; \
    /usr/bin/vim -S vim-plug-snapshot.vim +qall; \
    nvim -S nvim-plug-snapshot.vim +qall; \
    :; \
    rm -rf /home/${USERNAME}/.cache
