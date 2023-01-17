#!/usr/bin/env bash

# Ask for the sudoer password upfront
sudo -v

print_info "📦 Installing apps with APT…"

# Yarn repository
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update &&
	sudo apt install -y \
		awscli \
		dnsutils \
		fzf \
		git \
		jq \
		nodejs \
		openjdk-11-jdk \
		php8.1 \
		php8.1-intl \
		php8.1-json \
		php8.1-mbstring \
		php8.1-xml \
		php-pear \
		pkg-config \
		python \
		python-pip \
		python3 \
		python3-pip \
		runc \
		thefuck \
		tmux \
		tree \
		yarn \
		zsh

# Install Docker with convenience script
if ! [ -x "$(command -v docker)" ]; then
	print_info "🐳 Installing Docker…"
	curl -fsSL https://get.docker.com | sh
	sudo usermod -aG docker pi

	sudo apt install -y libffi-dev libssl-dev
	sudo pip3 install docker-compose
fi

# Install Kubernetes
if ! [ -x "$(command -v kubectl)" ]; then
	print_info "📦 Installing Kubernetes…"
	curl -sfL https://get.k3s.io | sh -
fi
