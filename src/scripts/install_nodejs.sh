#!/usr/bin/env bash
echo "Starting install NodeJS...................."
curl --silent --location https://deb.nodesource.com/setup_10.x | bash -
apt-get install --yes nodejs
apt-get install --yes build-essential

### Install Yarn
echo "Starting install yarn......................."
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt update && apt install yarn

