#!/bin/sh
cd ~
rm -rf frp_0.53.2_linux_amd64*
wget https://raw.githubusercontent.com/sugar-lover/AutoSSR/master/frp_0.53.2_linux_amd64.zip
apt update
apt install unzip
unzip frp_0.53.2_linux_amd64.zip
cd frp_0.53.2_linux_amd64/
./frps -c frps.toml