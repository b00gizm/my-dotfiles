#!/usr/bin/env bash

### Xcode Command Line Tools

# thx  https://github.com/alrra/dotfiles/blob/c2da74cc333/os/os_x/install_applications.sh#L39
if [ $(xcode-select -p &> /dev/null; printf $?) -ne 0 ]; then
    print_info "📦 Installing Xcode command line toolsi…"
    xcode-select --install &> /dev/null
    # Wait until the Xcode Command Line Tools are installed
    while [ $(xcode-select -p &> /dev/null; printf $?) -ne 0 ]; do
        sleep 5
    done
	xcode-select -p &> /dev/null
	if [ $? -eq 0 ]; then
        # Prompt user to agree to the terms of the Xcode license
        # https://github.com/alrra/dotfiles/issues/10
       sudo xcodebuild -license
   fi
fi

### Install Rosetta 2 legacy apps support
sudo softwareupdate --install-rosetta

### Homebrew
if ! [ -x "$(command -v brew)" ]; then
    print_info "📦 Installing Homebrew…"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

print_info "📦 Installing apps from ${DIR}/macos/Brewfile…"
brew update
brew bundle --file=${DIR}/macos/Brewfile
brew cleanup

# For Java wrappers to find the JDK
sudo ln -sfn /usr/local/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk