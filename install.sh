#!/bin/bash

DIRECTORY="$( cd "$( dirname "$0" )" && pwd )"

#
# Install dotfiles.
#

echo "Symlinking root-level dotfiles..."

find -L $DIRECTORY -maxdepth 1 -type f -name ".*" \
    -and -not -name ".gitignore" \
    -and -not -name "*.swp" \
    -print0 \
| xargs -0 -n1 -I{} ln -sf {} ~/

echo "Symlinking remaining paths..."

SYM_PATHS="
    .dstat \
    .python \
    .tmux \
    .vim \
    usr/bin \
    usr/contrib
"

for x in $SYM_PATHS; do
    mkdir -p ~/`dirname "$x"`
    ln -sf $DIRECTORY/"$x" ~/`dirname "$x"`
done

mkdir -p ~/.config
for x in `ls .config`; do
    ln -sf $DIRECTORY/.config/"$x" ~/.config/
done

mkdir -p ~/usr/local

#
# Activate new bashrc.
#
source ~/.bashrc
