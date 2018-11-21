#!/bin/bash
$port
$password

read -p "请输入要使用的端口号:" port
read -p "请输入要配置的密码:" password

echo "安装nano"
yum -y install nano

echo "安装git..."
yum -y install git

echo "clone代码..."
git clone -b manyuser https://github.com/shadowsocksr-backup/shadowsocksr.git
cd ~/shadowsocksr

echo "运行初始化脚本..."
bash initcfg.sh
cp user-config.json shadowsocks/user-config.json
cd shadowsocks/

echo "重写user-config.json..."
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


echo "开启端口..."
/sbin/iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport ${port} -j ACCEPT
/etc/init.d/iptables save

echo "重启服务..."
service iptables restart

echo "配置开机自启动"
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

echo "启动ssr服务..."
cd ~/shadowsocksr/shadowsocks
python server.py -d start



echo "部署ssr完成..."
