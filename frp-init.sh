#!/bin/sh
cd ~
rm -rf frp_0.53.2_linux_amd64*
wget https://sugoime.oss-cn-hangzhou.aliyuncs.com/frp/frp_0.53.2_linux_amd64.zip
apt update
apt install unzip
unzip frp_0.53.2_linux_amd64.zip
cd frp_0.53.2_linux_amd64/
chmod -R +x *
./frps -c frps.toml