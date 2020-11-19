#!/bin/bash
port
password="1984c5c8-2a30-11eb-adc1-0242ac120002"

read -p "请输入要使用的端口号:" port
# read -p "请输入要配置的密码:" password

echo -e "\033[41m  安装nano  \033[0m"
yum -y install nano

echo -e "\033[41m  执行自动脚本  \033[0m"
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

echo -e "\033[41m  编辑配置文件...  \033[0m"
cd /usr/local/etc/v2ray/

echo -e "\033[41m  重写config.json...  \033[0m"
echo "{
  \"inbounds\": [
    {
      \"port\": ${port},
      \"protocol\": \"vmess\",
      \"settings\": {
        \"clients\": [
          {
            \"id\": \"${password}\",
            \"alterId\": 64
          }
        ]
      }
    }
  ],
  \"outbounds\": [
    {
      \"protocol\": \"freedom\",
      \"settings\": {}
    }
  ]
}
"> config.json


echo -e "\033[41m  关闭防火墙...  \033[0m"
systemctl stop firewalld

echo -e "\033[41m  启动服务...  \033[0m"
systemctl start v2ray

echo "\033[41m  配置开机自启动...  \033[0m"
cd /etc/rc.d/init.d/
echo "#!/bin/bash
#chkconfig: 2345 80 90
#description:开机自动启动的脚本程序
systemctl stop firewalld
systemctl start v2ray

"> shadowsocksr.sh

chmod +x shadowsocksr.sh
chkconfig --add shadowsocksr.sh
chkconfig shadowsocksr.sh on

echo -e "\033[41m  部署ssr完成...  \033[0m"
