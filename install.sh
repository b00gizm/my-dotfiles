#!/usr/bin/env bash

echo "Creating or updating ${HOME}/.dotfiles…"
mkdir -p ${HOME}/.dotfiles; cd ${HOME}/.dotfiles
curl -fsSL https://github.com/b00gizm/my-dotfiles/tarball/master | tar -xzv --strip-components 1 --exclude={README.md,LICENSE}
cp ./exports.local.dist ./exports.local
sh -c ./shiny_new_machine.sh
