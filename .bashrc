#!/bin/bash

# ========================================================================
# OS-specific configuration
# ========================================================================

case $OSTYPE in
darwin*)
    export BASH_SILENCE_DEPRECATION_WARNING=1

    alias free='top -l1 -s0 | head -n 11'
    alias ls='ls -G'

    if [ -d /opt/homebrew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
    [[ -r "/Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh" ]] && source "/Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh"
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
# _mise
# ========================================================================

if [[ -x "$(command -v mise)" ]]; then
    eval "$(mise activate bash)"
fi

# ========================================================================
# _globals
# ========================================================================

if [[ -x "$(command -v nvim)" ]]; then
    export DEFAULT_VIM=nvim
else
    export DEFAULT_VIM=vim
fi

# ========================================================================
# _local packages
# ========================================================================

PATH=/usr/local/bin:/usr/local/sbin:$PATH:~/usr/bin
for x in `find $HOME/usr/local -maxdepth 1 | grep -v "\(bin\|include\|lib\|share\|src\)"`; do PATH=$PATH:$x/bin; done

# ========================================================================
# aliases
# ========================================================================

alias astronvim='NVIM_APPNAME=astronvim nvim'
alias df='df -h'
alias grep='grep --color'
alias dstat='dstat -t -c -l -d -Dsdc -r --postgres-conn'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias sshio="ssh -o IdentitiesOnly=yes"
alias sftppw="sftp -F /dev/null -o PreferredAuthentications=password -o PubkeyAuthentication=no"

# Default to nvim if available.
if [[ "$DEFAULT_VIM" && "$DEFAULT_VIM" != "vim" ]]; then
    alias vim="$DEFAULT_VIM"
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
function pyfind() { x=`python -c "import $1; print($1.__file__)" | sed 's/\.pyc$/\.py/'`; if [ $? -ne 0 ]; then exit $?; fi; grep -q "__init__.py$"<<<$x && echo `dirname $x` || echo $x; }

#-------------------------------------------------------------------------
# pycd()
#   change directory to path of Python module.
#-------------------------------------------------------------------------
function pycd() { cd $(dirname $(pyfind $1)); }

#-------------------------------------------------------------------------
# cless()
#   color less
#-------------------------------------------------------------------------
function cless () {
    pygmentize -f terminal "$1" | less -R
}

#-------------------------------------------------------------------------
# gctags()
#   run ctags only on files tracked in git
#   (from https://tbaggery.com/2011/08/08/effortless-ctags-with-git.html)
#-------------------------------------------------------------------------
function gctags () {
    trap 'rm -f "$$.tags"' EXIT
    git ls-files | \
      ctags -L - -f"$$.tags" .
    mv "$$.tags" "tags"
}

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

export EDITOR="$DEFAULT_VIM --noplugin"
export VISUAL="$EDITOR"
export PAGER="less"
if [ -f "/usr/share/source-highlight/src-hilite-lesspipe.sh" ]; then
    export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
fi
export LESS=-Ri
export HISTCONTROL='ignoreboth:erasedups'

# ========================================================================
# dircolors
# ========================================================================

if [ -x "$(command -v dircolors)" ]; then
    eval `dircolors $HOME/usr/contrib/dircolors-solarized/dircolors.256dark`
fi

# ========================================================================
# direnv
# ========================================================================

eval "$(direnv hook bash)"

# ========================================================================
# git-prompt
# ========================================================================

GIT_PS1_SHOWDIRTYSTATE="."

# ========================================================================
# golang
# ========================================================================

GVER_CURRENT_VERSION="$HOME/.gver/versions/current"
if [ -d "$GVER_CURRENT_VERSION/bin" ]; then
    PATH="$GVER_CURRENT_VERSION/bin:$PATH"
    export GOROOT="$GVER_CURRENT_VERSION"
fi

if [ -d "$HOME/Projects/go" ]; then
    export GOPATH="$HOME/Projects/go"
    PATH="$HOME/Projects/go/bin:$PATH"
fi

# ========================================================================
# nodejs
# ========================================================================

if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
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
COLOR_PROD="${ORANGE_BG}${BRIGHT}${WHITE}"

function jobcount {
    count=$(( $(jobs | wc -l) - 1 ))
    if [[ $count != 0 ]]; then
        echo -n "($count)"
    fi
}

function virtualenv_info() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        venv="${VIRTUAL_ENV##*/}"
    else
        venv=''
    fi
    [[ -n "$venv" ]] && echo -n "(venv:$venv) "
}

export VIRTUAL_ENV_DISABLE_PROMPT=1

PS1="[\$(date +%H:%M:%S)] "

PS1="$PS1\$(virtualenv_info)"

# username color conditional (root or regular user)
PS1="${PS1}$(if [[ $UID = 0 ]]; then echo $RED; else echo $CYAN; fi)"

# username/host and path
PS1="$PS1\u@\h:\[$BLUE\]\w\[$NORMAL\]\$(jobcount)"

# smiley
PS1="$PS1\[\`if [[ \$? != \"0\" ]]; then echo '$RED :($NORMAL'; fi\`"

# git
PS1="$PS1\$(__git_ps1)"

if [[ $USER == "vagrant" ]]; then
    PS1="$PS1 $COLOR_INFO DEV $NORMAL"
elif [[ -n $PROD_DOMAIN && ${HOSTNAME#*.*} == $PROD_DOMAIN ]]; then
    PS1="$PS1 $COLOR_PROD PRODUCTION $NORMAL"
elif [[ `hostname -d 2> /dev/null` == "ec2.internal" ]]; then
    # HACK: assuming hostnames that start with "ip-*" are EC2.
    PS1="$PS1 ${LTORANGE_BG}${BRIGHT}${WHITE} EC2 $NORMAL"
fi


PS1="$PS1"$'\n'"`if [[ $UID = 0 ]]; then echo '#'; else echo '\$'; fi` "

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

export POETRY_HOME=$HOME/usr/local/poetry
if [ -d "$POETRY_HOME" ]; then
    PATH="${POETRY_HOME}/bin:${PATH}"
fi

# uv
export PATH="$HOME/.local/bin:$PATH"

# ========================================================================
# ruby
# ========================================================================

if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$PATH:$(ruby -r rubygems -e 'puts Gem.user_dir')/bin"
fi

# ========================================================================
# rust
# ========================================================================

if [ -f $HOME/.cargo/env ]; then
    . "$HOME/.cargo/env"
fi

# ========================================================================
# sdkman
# ========================================================================

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# ========================================================================
# ssh
# ========================================================================

# Place SSH_AUTH_SOCK in a standard location.
AGENT_SOCK_LINK="$HOME/.ssh/agent_sock"
if [ "$SSH_AUTH_SOCK" != "$AGENT_SOCK_LINK" ] ; then
    # If AGENT_SOCK_LINK still points to a valid agent, don't relink it.
    if [[ ! $(SSH_AUTH_SOCK=$AGENT_SOCK_LINK ssh-add -L 2>/dev/null) ]]; then
        # Remove existing symlink if it exists, ignore errors if it doesn't
        [ -L "$AGENT_SOCK_LINK" ] && rm -f "$AGENT_SOCK_LINK"
        # Create new symlink
        ln -s "$SSH_AUTH_SOCK" "$AGENT_SOCK_LINK" 2>/dev/null || true
    fi

    export SSH_AUTH_SOCK="$AGENT_SOCK_LINK"
fi

# ========================================================================
# ~fin!
# ========================================================================

export PATH
for file in $(find $HOME/.bashrc.d/ -name "*.bashrc" 2>/dev/null); do
    source $file
done
