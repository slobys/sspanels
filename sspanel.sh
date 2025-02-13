#!/bin/bash

# Date : 2021-11-02 22:07:23
# Author : GZ
# Mail : v2board@qq.com
# Function : 脚本介绍
# Version : V1.0

# 检查用户是否为 root 用户
if [ $(id -u) != "0" ]; then
    echo "Error: 您必须是 root 才能运行此脚本，请使用 root 安装 sspanel"
    exit 1
fi

# 自动安装 PHP 8.2（如果未安装）
if ! command -v php8.2 >/dev/null 2>&1; then
    echo "未检测到 PHP 8.2，正在自动安装 PHP 8.2..."
    # 添加 ondrej/php PPA
    sudo add-apt-repository ppa:ondrej/php -y
    sudo apt update
    # 安装 PHP 8.2 及常用扩展
    sudo apt install -y php8.2-fpm php8.2-cli php8.2-mysql php8.2-curl php8.2-gd php8.2-mbstring php8.2-xml php8.2-xmlrpc php8.2-opcache php8.2-zip php8.2-bz2 php8.2-bcmath
    # 检查安装是否成功
    if ! command -v php8.2 >/dev/null 2>&1; then
        echo "Error: PHP 8.2 自动安装失败，请手动安装。"
        exit 1
    fi
fi

# 设置 PHP_CMD 变量，确保后续调用使用 php8.2
PHP_CMD="php8.2"

process() {
    install_date="sspanel_install_$(date +%Y-%m-%d_%H:%M:%S).log"
    printf "\033[36m#######################################################################
#                     欢迎使用 sspanel 一键部署脚本                     #
#                脚本适配环境 Ubuntu 18.04+/Debian 10+、内存1G+        #
#                请使用干净主机部署！                                 #
#                更多信息请访问 https://gz1903.github.io              #
#######################################################################\033[0m
"

    # 设置数据库密码
    while :; do
        echo
        read -p "请输入 Mysql 数据库 root 密码: " Database_Password
        [ -n "$Database_Password" ] && break
    done

    # 获取主机内网 IP
    ip="$(ifconfig | grep 'inet ' | awk '{print $2; exit;}')"
    # 获取主机外网 IP
    ips="$(curl ip.sb)"

    echo -e "\033[36m#######################################################################\033[0m"
    echo -e "\033[36m#                    正在安装常用组件 请稍等~                         #\033[0m"
    echo -e "\033[36m#######################################################################\033[0m"
    # 更新必备基础软件
    apt update && apt upgrade -y
    apt install -y curl vim wget unzip apt-transport-https lsb-release ca-certificates git gnupg2
    apt install software-properties-common

    echo -e "\033[36m#######################################################################\033[0m"
    echo -e "\033[36m#                  正在配置 Firewall 策略 请稍等~                       #\033[0m"
    echo -e "\033[36m#######################################################################\033[0m"
    sudo ufw allow 80

    echo -e "\033[36m#######################################################################\033[0m"
    echo -e "\033[36m#                 正在安装 MariaDB 数据库 请稍等~                       #\033[0m"
    echo -e "\033[36m#######################################################################\033[0m"
    sudo apt-get install software-properties-common dirmngr apt-transport-https
    sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
    sudo add-apt-repository 'deb [arch=amd64,arm64,ppc64el] https://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.5/ubuntu bionic main'
    sudo apt update
    sudo apt install mariadb-server -y

    echo -e "\033[36m#######################################################################\033[0m"
    echo -e "\033[36m#         正在安装 Nginx 环境  时间较长请稍等~                          #\033[0m"
    echo -e "\033[36m#######################################################################\033[0m"
    add-apt-repository ppa:ondrej/nginx -y
    apt update
    sudo apt install nginx -y
    sudo systemctl enable nginx
    nginx -V

    echo -e "\033[36m#######################################################################\033[0m"
    echo -e "\033[36m#         正在安装配置 PHP 环境及扩展  时间较长请稍等~                  #\033[0m"
    echo -e "\033[36m#######################################################################\033[0m"
    add-apt-repository ppa:ondrej/php -y
    apt update
    apt install -y php8.2-fpm php8.2-mysql php8.2-curl php8.2-gd php8.2-mbstring php8.2-xml php8.2-xmlrpc php8.2-opcache php8.2-zip php8.2-bz2 php8.2-bcmath
    sudo systemctl enable php8.2-fpm

    echo -e "\033[36m#######################################################################\033[0m"
    echo -e "\033[36m#                   正在配置 Mysql 数据库 请稍等~                       #\033[0m"
    echo -e "\033[36m#######################################################################\033[0m"
    mysqladmin -u root password "$Database_Password"
    echo -e "\033[36m数据库密码设置完成！\033[0m"
    # 数据库名称使用 sspanels（和后续 sed 保持一致）
    mysql -uroot -p$Database_Password -e "CREATE DATABASE sspanels CHARACTER set utf8 collate utf8_bin;"
    echo "正在创建 sspanels 数据库"

    echo -e "\033[36m#######################################################################\033[0m"
    echo -e "\033[36m#                    正在配置 Nginx 请稍等~                            #\033[0m"
    echo -e "\033[36m#######################################################################\033[0m"
    rm -rf /etc/nginx/sites-enabled/default
    rm -rf /etc/nginx/sites-available/sspanel.conf
    touch /etc/nginx/sites-available/sspanel.conf
    cat > /etc/nginx/sites-available/sspanel.conf << "eof"
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
        fastcgi_pass unix:/run/php/php8.2-fpm.sock;
    }
}
eof
    cd /etc/nginx/sites-enabled
    ln -s /etc/nginx/sites-available/sspanel.conf sspanel
    nginx -s reload

    echo -e "\033[36m#######################################################################\033[0m"
    echo -e "\033[36m#                   正在编译 sspanel 软件 请稍等~                       #\033[0m"
    echo -e "\033[36m#######################################################################\033[0m"
    rm -rf /var/www/*
    cd /var/www/
    git clone https://github.com/Anankke/SSPanel-UIM.git sspanels
    cd /var/www/sspanels/
    git config core.filemode false
    wget https://getcomposer.org/installer -O composer.phar
    echo -e "\033[32m软件下载安装中，时间较长请稍等~\033[0m"
    ${PHP_CMD} composer.phar install --no-dev --no-interaction --ignore-platform-req=ext-redis --ignore-platform-req=ext-yaml
    echo -e "\033[32m请输入yes确认安装！~\033[0m"
    ${PHP_CMD} composer.phar install --no-dev --no-interaction --ignore-platform-req=ext-redis --ignore-platform-req=ext-yaml
    chmod -R 755 ${PWD}
    chown -R www-data:www-data ${PWD}

    # 修改配置文件
    cd /var/www/sspanels/
    cp config/.config.example.php config/.config.php
    cp config/appprofile.example.php config/appprofile.php

    # ★★★ 重点：精准匹配含有 ; //注释 的行 ★★★
    # db_host 行 (如果没有注释，直接匹配)
    sed -i "s|\$ENV('db_host')     = '';|\$ENV('db_host')     = '127.0.0.1';|" /var/www/sspanels/config/.config.php

    # db_database 行 (含 ; //数据库名 注释)
    sed -i "s|\$ENV('db_database') = 'sspanel'; //数据库名|\$ENV('db_database') = 'sspanels'; //数据库名|" /var/www/sspanels/config/.config.php

    # db_username 行 (含 ; //数据库用户名 注释)
    sed -i "s|\$ENV('db_username') = 'root'; //数据库用户名|\$ENV('db_username') = 'root'; //数据库用户名|" /var/www/sspanels/config/.config.php

    # db_password 行 (含 ; //用户密码 注释)
    sed -i "s|\$ENV('db_password') = 'sspanel'; //用户密码|\$ENV('db_password') = '$Database_Password'; //用户密码|" /var/www/sspanels/config/.config.php

    echo "当前数据库配置："
    grep 'db_' /var/www/sspanels/config/.config.php

    echo "请根据项目文档初始化数据库（例如执行迁移命令）！"
    echo "设置管理员账号："
    ${PHP_CMD} xcat User createAdmin
    ${PHP_CMD} xcat User resetTraffic
    ${PHP_CMD} xcat Tool initQQWry

    nginx -s reload
    echo "服务启动完成"

    echo -e "\033[32m--------------------------- 安装已完成 ---------------------------\033[0m"
    echo -e "\033[32m 数据库名     : sspanels\033[0m"
    echo -e "\033[32m 数据库用户名 : root\033[0m"
    echo -e "\033[32m 数据库密码   : $Database_Password\033[0m"
    echo -e "\033[32m 网站目录     : /var/www/sspanels\033[0m"
    echo -e "\033[32m 配置目录     : /var/www/sspanels/config/.config.php\033[0m"
    echo -e "\033[32m 网页内网访问 : http://$ip\033[0m"
    echo -e "\033[32m 网页外网访问 : http://$ips\033[0m"
    echo -e "\033[32m 安装日志文件 : /var/log/$install_date\033[0m"
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
