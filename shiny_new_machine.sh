#!/usr/bin/env bash

DIR=$(dirname "${BASH_SOURCE}")

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
        read -p "$(print_warning "You're about to overwrite '$1'. Continue? (y/n) ")" -n 1
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

### Install Powerlevel10k
print_info "📦 Installing powerlevel10k…"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install z.sh
print_info "📦 Installing z - Jump around…"
curl -fLo ~/.z.sh https://raw.githubusercontent.com/rupa/z/master/z.sh && chmod +x ~/.z.sh

### Install nvm Node Version Manager
print_info "📦 Installing Node.js LTS (nvm) incl. various dev tools"
if ! [ -d "${HOME}/.nvm" ]; then
    NVM_VERSION="v0.39.0"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash
fi
. ${NVM_DIR}/nvm.sh
nvm install --lts
nvm use --lts

### Install Xdebug for PHP
if [ "$(php -v >/dev/null 2>&1)" ] && ! [ "$(php -m | grep Xdebug)" ]; then
    print_info "🐞 Installing Xdebug for PHP…"
    XDEBUG_VERSION="3.1.1"
    curl -fLo /tmp/xdebug-${XDEBUG_VERSION}.tgz http://xdebug.org/files/xdebug-${XDEBUG_VERSION}.tgz
    tar -xvzf /tmp/xdebug-${XDEBUG_VERSION}.tgz -C /tmp
    pushd /tmp/xdebug-${XDEBUG_VERSION}
    phpize && ./configure && make
    extensionDir="$(php -i | sed -n '/^extension_dir/p' | awk '{print $5}')"
    sudo cp modules/xdebug.so ${extensionDir}
    phpIniFile="$(php -i | sed -n '/^Loaded Configuration File/p' | awk '{print $5}')"
    echo "zend_extension = ${extensionDir}/xdebug.so" | sudo tee -a ${phpIniFile} >/dev/null
    popd
fi

print_info "🚀 Configuring SpaceVim…"
mkdir -p ${HOME}/.config/nvim
curl -sLf https://spacevim.org/install.sh | bash

print_info "⚡️ Writing .zshrc…"
if check_overwrite ${HOME}/.zshrc; then
    zshrcFile=${DIR}/.zshrc
    rm ${HOME}/.zshrc 2>/dev/null
    ln -s "$(
        cd "$(dirname "${zshrcFile}")"
        pwd -P
    )/$(basename "${zshrcFile}")" ${HOME}/.zshrc
fi

echo ""
print_success "🎉 All done! Enjoy your new machine."
