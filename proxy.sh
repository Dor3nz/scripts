#!/bin/bash

# MIT License

# Copyright (c) 2019 Dor3nz

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# 
#
# This script configures NPM, Git and EXPORT vars to be used in a corporate proxy environment.

echo Hello, this will configure the proxy for NPM, git and EXPORT vars.

showshelloptions() {
  echo First of all, I need to know your shell:
  echo 1. bash
  echo 2. zsh
}

bashchosen=0

while [ "$bashchosen" -eq 0 ] ; do
  showshelloptions
  read -p 'Enter 1 or 2 and hit RETURN: ' shell

  case $shell in
    "1")
      echo "Chosen bash."
      shellfile=~/.bashrc
      bashchosen=1
      ;;
    "2")
      echo "Chosen zsh."
      shellfile=~/.zshrc
      bashchosen=1
      ;;
    *)
      echo "Shell not found. Please enter 1 or 2."
      ;;
  esac
done


read -p 'Proxy server: ' proxyserver
read -p 'Proxy port: ' proxyport
read -p 'Your proxy username: ' username

stty -echo
read -p 'Your proxy password: ' password
stty echo

# Build the proxy string
echo "Built string http://${username}:****@${proxyserver}:${proxyport}"
proxy_string=http://$username:$password@$proxyserver:$proxyport

# Set up NPM
echo "Setting up npm..."
npm config set proxy $proxy_string
npm config set https-proxy $proxy_string

# Set up Git
echo "Setting up git..."
git config --global http.proxy $proxy_string
git config --global https.proxy $proxy_string

# Set up EXPORT at shell rc file
# TODO: Remove export vars first
echo "Setting up EXPORT vars..."
echo "http_proxy=${proxy_string}" >> $shellfile
echo "https_proxy=${proxy_string}" >> $shellfile

# Set up .curlrc
echo "Setting up .curlc..."
echo "proxy = ${proxy_string}" >> ~/.curlrc

# Source from shell file to load export vars
source $shellfile

