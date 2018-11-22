#!/bin/bash
port="9090"
password=""
istcp="y"
choose_y="y"
choose_n="n"

read -p "请输入要使用的端口号:" port
read -p "请输入要配置的密码:" password

echo -e "\033[41m  安装nano  \033[0m"
yum -y install nano

echo -e "\033[41m  安装git...  \033[0m"
yum -y install git

echo -e "\033[41m  clone代码...  \033[0m"
git clone -b manyuser https://github.com/shadowsocksr-backup/shadowsocksr.git
cd ~/shadowsocksr

echo -e "\033[41m  运行初始化脚本...  \033[0m"
bash initcfg.sh
cp user-config.json shadowsocks/user-config.json
cd shadowsocks/

echo -e "\033[41m  重写user-config.json...  \033[0m"
echo "{
    \"server\":\"0.0.0.0\",
    \"server_ipv6\":\"[::]\",
    \"local_address\":\"127.0.0.1\",
    \"local_port\":1080,
    \"port_password\":{
        \"${port}\":\"${password}\"
    },
    \"timeout\":120,
    \"method\":\"aes-256-cfb\",
    \"protocol\":\"auth_sha1_v4\",
    \"protocol_param\":\"\",
    \"obfs\":\"http_simple\",
    \"obfs_param\":\"\"
}
"> user-config.json


echo -e "\033[41m  开启端口...  \033[0m"
/sbin/iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport ${port} -j ACCEPT
/etc/init.d/iptables save

echo -e "\033[41m  重启服务...  \033[0m"
service iptables restart

echo "\033[41m  配置开机自启动...  \033[0m"
cd /etc/rc.d/init.d/
echo "#!/bin/bash
#chkconfig: 2345 80 90
#description:开机自动启动的脚本程序
cd ~/shadowsocksr/shadowsocks/
python server.py -d restart

"> shadowsocksr.sh

chmod +x shadowsocksr.sh
chkconfig --add shadowsocksr.sh
chkconfig shadowsocksr.sh on

echo -e "\033[41m  启动ssr服务...  \033[0m"
cd ~/shadowsocksr/shadowsocks
python server.py -d start

echo -e "\033[41m  部署ssr完成...  \033[0m"
