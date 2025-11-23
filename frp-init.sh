#!/bin/sh
echo -e "\033[41m  开始安装  \033[0m"
cd ~

echo -e "\033[41m  清理目录  \033[0m"
rm -rf frp_0.53.2_linux_amd64*

echo -e "\033[41m  wget  \033[0m"
wget https://sugoime.oss-cn-hangzhou.aliyuncs.com/frp/frp_0.53.2_linux_amd64.zip

echo -e "\033[41m  apt update  \033[0m"
apt update

echo -e "\033[41m  install unzip  \033[0m"
apt install unzip

echo -e "\033[41m  unzip  \033[0m"
unzip frp_0.53.2_linux_amd64.zip

cd frp_0.53.2_linux_amd64/

echo -e "\033[41m  chmod  \033[0m"
chmod -R +x *

echo -e "\033[41m  运行  \033[0m"
./frps -c frps.toml