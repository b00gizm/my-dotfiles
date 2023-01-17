#!/usr/bin/env bash

exec 2>&1
set -x

rm -f ${HOME}/.zshrc

sudo chsh -s "$(which zsh)" "$(whoami)"

sudo apt-get update
sudo apt-get install -y \
  fzf \
  python3-dev \
  python3-pip \
  python3-setuptools \
  tmux &&
  pip3 install thefuck --user
