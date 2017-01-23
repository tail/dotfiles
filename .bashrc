#!/bin/bash

# ========================================================================
# OS-specific configuration
# ========================================================================

case $OSTYPE in
darwin14|darwin15|darwin16)
    alias free='top -l1 -s0 | head -n 11'
    alias ls='ls -G'

    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi
;;
linux-gnu)
    alias ls='ls --color'

    if [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi

    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'

    if [[ "z$TMUX" == "z" ]]; then
        export TERM=xterm-256color
    fi
;;
esac

# ========================================================================
# _local packages
# ========================================================================

PATH=/usr/local/bin:/usr/local/sbin:$PATH:~/usr/bin
for x in `find $HOME/usr/local -maxdepth 1 | grep -v "\(bin\|include\|lib\|share\|src\)"`; do PATH=$PATH:$x/bin; done

# ========================================================================
# _linuxbrew
# ========================================================================

if [ -d "$HOME/.linuxbrew" ]; then
    PATH="$HOME/.linuxbrew/bin:$PATH"
    export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
    export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
fi

# ========================================================================
# aliases
# ========================================================================

alias df='df -h'
alias grep='grep --color'
alias dstat='dstat -t -c -l -d -Dsdc -r --postgres-conn'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

# Default to nvim if available.
if [[ -x "$(command -v nvim)" ]]; then
    alias vim=nvim
fi

# ========================================================================
# functions
# ========================================================================

#-------------------------------------------------------------------------
# f()
#   ghetto "find pattern in files matching extension".
#-------------------------------------------------------------------------
function f() {
    find . -name "*.$1" -print0 | xargs -0 grep -P -nH --color "${@:2}"
}

#-------------------------------------------------------------------------
# dugt()
#   find files/directories recursively that are greater than 1GB.
#-------------------------------------------------------------------------
function dugt() {
    # FIXME: I can't get this damn "lower" variable to work
    if [ -z "$1" ]; then
        lower=1
    else
        lower="$1"
    fi

    du -ha | awk 'x=substr($1, 0, length($1)-1) {if ($1 ~ /G/ && int(x) > 1.0) {print $0}}'
}

#-------------------------------------------------------------------------
# scplimit()
#   rsync bwlimit wrapper
#-------------------------------------------------------------------------
function scplimit() {
    if [ -z "$3" ]; then
        bwlimit="20"
    else
        bwlimit="$3"
    fi

    rsync --stats --progress --bwlimit=$bwlimit -v --rsh=ssh "$1" "$2"
}

#-------------------------------------------------------------------------
# pyfind()
#   find importable Python module path.
#-------------------------------------------------------------------------
function pyfind() { x=`python -c "import $1; print $1.__file__" | sed 's/\.pyc$/\.py/'`; if [ $? -ne 0 ]; then exit $?; fi; grep -q "__init__.py$"<<<$x && echo `dirname $x` || echo $x; }

#-------------------------------------------------------------------------
# pycd()
#   change directory to path of Python module.
#-------------------------------------------------------------------------
function pycd() { cd $(dirname $(pyfind $1)); }

# ========================================================================
# android
# ========================================================================

if [ -d "$HOME/Android/Sdk" ]; then
    export ANDROID_HOME="$HOME/Android/Sdk"
    PATH=${PATH}:${ANDROID_HOME}/tools
    PATH=${PATH}:${ANDROID_HOME}/platform-tools
fi

# ========================================================================
# autojump
# ========================================================================

source $HOME/usr/contrib/autojump/bin/autojump.bash

# ========================================================================
# base16
# ========================================================================

if $(echo $- | grep -q "i"); then
    export BASE16_SHELL="$HOME/usr/contrib/base16-shell"
    [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
    _base16 "$HOME/usr/contrib/base16-shell/scripts/base16-solarized-dark.sh" solarized-dark
fi

# ========================================================================
# bash
# ========================================================================

export EDITOR="vim --noplugin"
export VISUAL="vim --noplugin"
export PAGER=~/usr/bin/vimpager
export LESS=-Ri
export HISTCONTROL='ignoreboth:erasedups'

# ========================================================================
# dircolors
# ========================================================================

if [ -x "$(command -v dircolors)" ]; then
    eval `dircolors $HOME/usr/contrib/dircolors-solarized/dircolors.256dark`
fi

# ========================================================================
# docker version manager
# ========================================================================

if [ -d "$HOME/.dvm" ]; then
    source "$HOME/.dvm/dvm.sh"
fi

# ========================================================================
# git-prompt
# ========================================================================

GIT_PS1_SHOWDIRTYSTATE="."

# ========================================================================
# golang
# ========================================================================

if [ -d "$HOME/Projects/go" ]; then
    export GOPATH="$HOME/Projects/go"
    PATH="$HOME/Projects/go/bin:$PATH"
fi

# ========================================================================
# minimesos
# ========================================================================

if [ -d "$HOME/.minimesos" ]; then
    PATH=$PATH:$HOME/.minimesos/bin
fi

# ========================================================================
# nodejs
# ========================================================================

if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR=$HOME/.nvm
    # HACK: sourcing "nvm.sh" is slow.  right now we're just manually
    # specifying the version of node we're using.
    # see https://github.com/creationix/nvm/issues/860
    export NODE_VERSION="v6.9.4"
    NODE_BIN_DIR="${NVM_DIR}/versions/node/${NODE_VERSION}/bin"
    if [ -d ${NODE_BIN_DIR} ]; then
        source ${NVM_DIR}/nvm.sh --no-use
        PATH="${PATH}:${NODE_BIN_DIR}"
    else
        echo "WARNING: Node ${NODE_VERSION} is not installed, falling back to slow method."
        source ${NVM_DIR}/nvm.sh
    fi
fi

# ========================================================================
# PS1
# ========================================================================

# Color definitions
if [[ $- == *i* && -x "$(command -v tput)" ]]; then
    BLACK=$(tput setaf 0)
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    LIME_YELLOW=$(tput setaf 190)
    POWDER_BLUE=$(tput setaf 153)
    BLUE=$(tput setaf 4)
    MAGENTA=$(tput setaf 5)
    CYAN=$(tput setaf 6)
    WHITE=$(tput setaf 7)
    BRIGHT=$(tput bold)
    NORMAL=$(tput sgr0)
    BLINK=$(tput blink)
    REVERSE=$(tput smso)
    UNDERLINE=$(tput smul)

    GREEN_BG=$(tput setab 2)
    LTORANGE_BG=$(tput setab 4)
    ORANGE_BG=$(tput setab 9)
else
    BLACK="\033[1;30m"
    RED="\033[1;31m"
    GREEN="\033[1;32m"
    BROWN="\033[1;33m"
    BLUE="\033[1;34m"
    PURPLE="\033[1;35m"
    CYAN="\033[1;36m"
    WHITE="\033[1;37m"
    NORMAL="\033[0;39m"
    BRIGHT="\033[1m"

    GREEN_BG="\033[1;42m"
    LTORANGE_BG="\033[1;44m"
    ORANGE_BG="\033[1;101m"
fi

COLOR_INFO="${GREEN_BG}${BRIGHT}${WHITE}"

function jobcount {
    count=$(( $(jobs | wc -l) ))
    if [[ $count != 0 ]]; then
        echo -n "($count)"
    fi
}

# username color conditional (root or regular user)
PS1=`if [[ $UID = 0 ]]; then echo $RED; else echo $CYAN; fi`

# username/host and path
PS1="$PS1 \u@\h:\[$BLUE\]\w\[$NORMAL\]\$(jobcount)"

# smiley
PS1="$PS1\[\`if [[ \$? != \"0\" ]]; then echo '$RED :($NORMAL'; fi\`"

# git
PS1="$PS1\$(__git_ps1)"

if [[ $USER == "vagrant" ]]; then
    PS1="$PS1 $COLOR_INFO DEV $NORMAL"
elif [[ `hostname -d 2> /dev/null` == "ec2.internal" ]]; then
    # HACK: assuming hostnames that start with "ip-*" are EC2.
    PS1="$PS1 ${LTORANGE_BG}${BRIGHT}${WHITE} EC2 $NORMAL"
fi


PS1="$PS1"$'\n'"`if [[ $UID = 0 ]]; then echo '#'; else echo '\$'; fi` "

export PROMPT_COMMAND="echo -n \[\$(date +%H:%M:%S)\]"

# Support xterm titles.
case $TERM in
    xterm*)
        PS1="\[\033]0;\h: \w\007\]${PS1}"
        ;;
esac

# ========================================================================
# python
# ========================================================================

export PYTHONDONTWRITEBYTECODE=1
export PYTHONPATH=$HOME/.python

# ========================================================================
# ssh
# ========================================================================

# Place SSH_AUTH_SOCK in a standard location.
AGENT_SOCK_LINK="$HOME/.ssh/agent_sock"
if [ ! -z "$SSH_AUTH_SOCK" -a "$SSH_AUTH_SOCK" != "$AGENT_SOCK_LINK" ] ; then
    # If AGENT_SOCK_LINK still points to a valid agent, don't relink it.
    if [[ ! $(SSH_AUTH_SOCK=$AGENT_SOCK_LINK ssh-add -L 2>/dev/null) ]]; then
        unlink "$AGENT_SOCK_LINK" 2>/dev/null
        ln -s "$SSH_AUTH_SOCK" "$AGENT_SOCK_LINK"
    fi

    export SSH_AUTH_SOCK="$AGENT_SOCK_LINK"
fi

# ========================================================================
# virtualenv
# ========================================================================

if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi

# Add sandbox virtualenv to PATH last, if it exists.  This is so things like
# ipython/flake8 don't need to be installed globally.
if [ -d $HOME/.virtualenvs/sandbox/bin ]; then
    PATH=$PATH:$HOME/.virtualenvs/sandbox/bin
fi

# ========================================================================
# ~fin!
# ========================================================================

export PATH
for file in $(find $HOME/.bashrc.d/ -name "*.bashrc" 2>/dev/null); do
	source $file
done
