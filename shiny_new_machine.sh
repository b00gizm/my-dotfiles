#!/usr/bin/env bash

DIR=$(dirname "${BASH_SOURCE}");

### Helpers
print_header() {
    echo "   _____ __    _                _   __                __  ___           __    _            "
    echo "  / ___// /_  (_)___  __  __   / | / /__ _      __   /  |/  /___ ______/ /_  (_)___  ___   "
    echo "  \__ \/ __ \/ / __ \/ / / /  /  |/ / _ \ | /| / /  / /|_/ / __ \`/ ___/ __ \/ / __ \/ _ \\"
    echo " ___/ / / / / / / / / /_/ /  / /|  /  __/ |/ |/ /  / /  / / /_/ / /__/ / / / / / / /  __/  "
    echo "/____/_/ /_/_/_/ /_/\__, /  /_/ |_/\___/|__/|__/  /_/  /_/\__,_/\___/_/ /_/_/_/ /_/\___/   "
    echo "                   /____/                                                                  "
    echo "                                                                                           " 

}

print_info() {
    # Print output in purple
    printf "\n\e[0;35m $1\e[0m\n\n"
}

print_warning() {
    # Print output in yellow
    printf "\e[0;33m  [!] $1\e[0m\n"
}

print_success() {
    # Print output in green
    printf "\e[0;32m  [✔] $1\e[0m\n"
}

check_overwrite() {
    if [ -f "$1" ]; then
        read -p "$(print_warning "You're about to overwrite '$1'. Continue? (y/n) ")" -n 1;
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            true
        else
            false
        fi
    else
        true
    fi
}


print_header

if [[ "$OSTYPE" == "darwin"* ]]; then
    print_info "💻 WELCOME TO YOUR BRAND NEW MAC! LET ME SET IT UP FOR YOU…"
    source ${DIR}/macos/init.sh
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [[ "$(lsb_release -si)" == "Raspbian" ]]; then
        print_info "🍓 WELCOME TO YOUR BRAND NEW RASPBERRY PI! LET ME SET IT UP FOR YOU…"
        source ${DIR}/raspbian/init.sh
    fi
fi

### Install oh-my-zsh
print_info "📦 Installing oh-my-zsh…"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install z.sh
print_info "📦 Installing z - Jump around…"
curl -fLo ~/.z.sh https://raw.githubusercontent.com/rupa/z/master/z.sh && chmod +x ~/.z.sh

### Install nvm Node Version Manager
if ! [ -d "${HOME}/.nvm" ]; then
    print_info "📦 Installing nvm…"
    NVM_VERSION="v0.35.3"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash
fi
. ${NVM_DIR}/nvm.sh; nvm install --lts; nvm use --lts

### Install various dev tools via NPM
npm install -g \
    @angular/cli \
    gatsby-cli \
    typescript

print_info "🤓 Configuring Neovim…"
mkdir -p ${HOME}/.config/nvim
pip3 install --user --upgrade autopep8 flake8 pynvim
pecl install msgpack
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
initFile=${DIR}/.config/nvim/init.vim
if check_overwrite ${HOME}/.config/nvim/init.vim; then 
    rm ${HOME}/.config/nvim/init.vim 2>/dev/null
    ln -s "$(cd "$(dirname "${initFile}")"; pwd -P)/$(basename "${initFile}")" ${HOME}/.config/nvim/init.vim
fi
print_info "💡 Install Neovim plugins with 'nvim +PlugInstall'"

print_info "⚡️ Writing .zshrc…"
if check_overwrite ${HOME}/.zshrc; then
    zshrcFile=${DIR}/.zshrc
    rm ${HOME}/.zshrc 2>/dev/null
    ln -s "$(cd "$(dirname "${zshrcFile}")"; pwd -P)/$(basename "${zshrcFile}")" ${HOME}/.zshrc
fi

echo ""
print_success "🎉 All done! Enjoy your new machine."
