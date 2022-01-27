#!/bin/bash

git subtree pull --squash --prefix usr/contrib/autojump https://github.com/wting/autojump.git master
git subtree pull --squash --prefix usr/contrib/base16-shell https://github.com/chriskempson/base16-shell.git master
git subtree pull --squash --prefix usr/contrib/dircolors-solarized https://github.com/seebi/dircolors-solarized master
git subtree pull --squash --prefix usr/contrib/duviz https://github.com/soxofaan/duviz master
git subtree pull --squash --prefix usr/contrib/transcrypt https://github.com/elasticdog/transcrypt master
git subtree pull --squash --prefix .tmux/plugins/tmux-yank https://github.com/tmux-plugins/tmux-yank.git master
git subtree pull --squash --prefix usr/contrib/git-filter-repo https://github.com/newren/git-filter-repo main
