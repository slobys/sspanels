#!/bin/bash

# Date : 2021-11-02 22:07:23
# Author : GZ
# Mail : v2board@qq.com
# Function : 脚本介绍
# Version : V1.0

# 检查用户是否为root用户
if [ $(id -u) != "0" ]; then
    echo "Error: 您必须是root才能运行此脚本，请使用root安装sspanel"
    exit 1
fi

process() {
    install_date="sspanel_install_$(date +%Y-%m-%d_%H:%M:%S).log"
    printf "\033[36m#######################################################################
#                     欢迎使用sspanel一键部署脚本                     #
#                脚本适配环境Ubuntu 18.04+/Debian 10+、内存1G+        #
#                请使用干净主机部署！                                 #
#                更多信息请访问 https://gz1903.github.io              #
#######################################################################\033[0m
"

    # 设置数据库密码
    while :; do
        echo
        read -p "请输入Mysql数据库root密码: " Database_Password 
        [ -n "$Database_Password" ] && break
    done

    # 获取主机内网ip
    ip="$(ifconfig | grep 'inet ' | awk '{print $2; exit;}')"
    # 获取主机外网ip
    ips="$(curl ip.sb)"

    echo -e "\033[36m#######################################################################\033[0m"
    echo -e "\033[36m#                                                                     #\033[0m"
    echo -e "\033[36m#                    正在安装常用组件 请稍等~                         #\033[0m"
    echo -e "\033[36m#                                                                     #\033[0m"
    echo -e "\033[36m#######################################################################\033[0m"
    # 更新必备基础软件
    apt update && apt upgrade -y
    apt install -y curl vim wget unzip apt-transport-https lsb-release ca-certificates git gnupg2
    # 更新PPA软件源
    apt install software-properties-common

    echo -e "\033[36m#######################################################################\033[0m"
    echo -e "\033[36m#                                                                     #\033[0m"
    echo -e "\033[36m#                  正在配置Firewall策略 请稍等~                       #\033[0m"
    echo -e "\033[36m#                                                                     #\033[0m"
    echo -e "\033[36m#######################################################################\033[0m"
    sudo ufw allow 80
    # 放行TCP80端口

    echo -e "\033[36m#######################################################################\033[0m"
    echo -e "\033[36m#                                                                     #\033[0m"
    echo -e "\033[36m#                 正在安装MariaDB数据库 请稍等~                       #\033[0m"
    echo -e "\033[36m#                                                                     #\033[0m"
    echo -e "\033[36m#######################################################################\033[0m"
    # MariaDB 安装
    sudo apt-get install software-properties-common dirmngr apt-transport-https
    sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
    sudo add-apt-repository 'deb [arch=amd64,arm64,ppc64el] https://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.5/ubuntu bionic main'
    sudo apt update
    sudo apt install mariadb-server -y

    echo -e "\033[36m#######################################################################\033[0m"
    echo -e "\033[36m#                                                                     #\033[0m"
    echo -e "\033[36m#         正在安装Nginx环境  时间较长请稍等~                          #\033[0m"
    echo -e "\033[36m#                                                                     #\033[0m"
    echo -e "\033[36m#######################################################################\033[0m"
    # 安装Nginx
    add-apt-repository ppa:ondrej/nginx -y
    apt update
    sudo apt install nginx -y
    sudo systemctl enable nginx
    nginx -V

    echo -e "\033[36m#######################################################################\033[0m"
    echo -e "\033[36m#                                                                     #\033[0m"
    echo -e "\033[36m#         正在安装配置PHP环境及扩展  时间较长请稍等~                  #\033[0m"
    echo -e "\033[36m#                                                                     #\033[0m"
    echo -e "\033[36m#######################################################################\033[0m"
    # 安装PHP 7.3及扩展
    add-apt-repository ppa:ondrej/php -y
    apt update
    apt install -y php7.3-fpm php7.3-mysql php7.3-curl php7.3-gd php7.3-mbstring php7.3-xml php7.3-xmlrpc php7.3-opcache php7.3-zip php7.3 php7.3-json php7.3-bz2 php7.3-bcmath
    sudo systemctl enable php7.3-fpm

    echo -e "\033[36m#######################################################################\033[0m"
    echo -e "\033[36m#                                                                     #\033[0m"
    echo -e "\033[36m#                   正在配置Mysql数据库 请稍等~                       #\033[0m"
    echo -e "\033[36m#                                                                     #\033[0m"
    echo -e "\033[36m#######################################################################\033[0m"
    # 修改数据库密码及创建数据库
    mysqladmin -u root password "$Database_Password"
    echo -e "\033[36m数据库密码设置完成！\033[0m"
    mysql -uroot -p$Database_Password -e \"CREATE DATABASE sspanel CHARACTER set utf8 collate utf8_bin;\"
    echo "正在创建sspanel数据库"

    echo -e "\033[36m#######################################################################\033[0m"
    echo -e "\033[36m#                                                                     #\033[0m"
    echo -e "\033[36m#                    正在配置Nginx 请稍等~                            #\033[0m"
    echo -e "\033[36m#                                                                     #\033[0m"
    echo -e "\033[36m#######################################################################\033[0m"
    # 更新 Nginx 配置（注意：将站点根目录统一改为 /var/www/sspanels/public）
    rm -rf /etc/nginx/sites-enabled/default
    rm -rf /etc/nginx/sites-available/sspanel.conf
    touch /etc/nginx/sites-available/sspanel.conf
    cat > /etc/nginx/sites-available/sspanel.conf <<\"eof\"
server {  
    listen 80;
    listen [::]:80;
    root /var/www/sspanels/public; # 请确保目录存在且以 /public 结尾
    index index.php index.html;
    # server_name https://gz1903.github.io;

    location / {
        try_files $uri /index.php$is_args$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.3-fpm.sock;
    }
}
eof
    cd /etc/nginx/sites-enabled
    ln -s /etc/nginx/sites-available/sspanel.conf sspanel
    nginx -s reload

    echo -e "\033[36m#######################################################################\033[0m"
    echo -e "\033[36m#                                                                     #\033[0m"
    echo -e "\033[36m#                   正在编译sspanel软件 请稍等~                       #\033[0m"
    echo -e "\033[36m#                                                                     #\033[0m"
    echo -e "\033[36m#######################################################################\033[0m"
    # 清空原有目录（注意：这一步将删除 /var/www/ 下所有文件，请谨慎使用）
    rm -rf /var/www/*
    cd /var/www/
    # 克隆项目到目标目录（确保名称一致，这里统一使用 sspanels 作为目录名）
    git clone https://github.com/Anankke/SSPanel-UIM.git sspanels
    # 下载 composer
    cd /var/www/sspanels/
    git config core.filemode false
    wget https://getcomposer.org/installer -O composer.phar
    echo -e "\033[32m软件下载安装中，时间较长请稍等~\033[0m"
    # 安装 PHP 依赖（加入 --no-interaction 及忽略平台扩展检查，如果需要可加 --ignore-platform-req 参数）
    php composer.phar install --no-dev --no-interaction
    echo -e "\033[32m请输入yes确认安装！~\033[0m"
    php composer.phar install --no-dev --no-interaction
    # 调整目录权限
    chmod -R 755 ${PWD}
    chown -R www-data:www-data ${PWD}

    # 修改配置文件
    cd /var/www/sspanels/
    cp config/.config.example.php config/.config.php
    cp config/appprofile.example.php config/appprofile.php
    # 设置 sspanels 数据库连接（随机 key 保证安全）
    sed -i "s/1145141919810/aksgsj@h$RANDOM/" /var/www/sspanels/config/.config.php
    # 站点名称
    sed -i "s/sspanels/飞一般的感觉/" /var/www/sspanels/config/.config.php
    # 站点地址
    sed -i "s|https://sspanels.host|http://$ips|" /var/www/sspanels/config/.config.php
    # 校验魔改后端请求的 key
    sed -i "s/NimaQu/sadg^#@s$RANDOM/" /var/www/sspanels/config/.config.php
    # 设置数据库连接地址
    sed -i "s/host'\]      = ''/host'\]      = '127.0.0.1'/" /var/www/sspanels/config/.config.php
    # 设置数据库连接密码
    sed -i "s/password'\]  = 'sspanels'/password'\]  = '$Database_Password'/" /var/www/sspanels/config/.config.php
    # 导入数据库文件
    mysql -uroot -p$Database_Password sspanels < /var/www/sspanels/sql/glzjin_all.sql;
    echo "设置管理员账号："
    php xcat User createAdmin
    # 重置所有流量
    php xcat User resetTraffic
    # 下载 IP 地址库
    php xcat Tool initQQWry

    nginx -s reload
    echo "服务启动完成"

    echo -e "\033[32m--------------------------- 安装已完成 ---------------------------\033[0m"
    echo -e "\033[32m 数据库名     :sspanel\033[0m"
    echo -e "\033[32m 数据库用户名 :root\033[0m"
    echo -e "\033[32m 数据库密码   :$Database_Password\033[0m"
    echo -e "\033[32m 网站目录     :/var/www/sspanels\033[0m"
    echo -e "\033[32m 配置目录     :/var/www/sspanels/config/.config.php\033[0m"
    echo -e "\033[32m 网页内网访问 :http://$ip\033[0m"
    echo -e "\033[32m 网页外网访问 :http://$ips\033[0m"
    echo -e "\033[32m 安装日志文件 :/var/log/$install_date\033[0m"
    echo -e "\033[32m------------------------------------------------------------------\033[0m"
    echo -e "\033[32m 如果安装有问题请反馈安装日志文件。\033[0m"
    echo -e "\033[32m 使用有问题请在这里寻求帮助:https://gz1903.github.io\033[0m"
    echo -e "\033[32m 电子邮箱:v2board@qq.com\033[0m"
    echo -e "\033[32m------------------------------------------------------------------\033[0m"
}

LOGFILE=/var/log/sspanel_install_$(date +%Y-%m-%d_%H:%M:%S).log
touch $LOGFILE
tail -f $LOGFILE &
pid=$!
exec 3>&1
exec 4>&2
exec &>$LOGFILE
process
ret=$?
exec 1>&3 3>&-
exec 2>&4 4>&-
