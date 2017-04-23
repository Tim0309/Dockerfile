#!/bin/bash

set -ex
# 本脚本初始化适用yum安装的mariadb

# 启动 mysql
mysqld_safe --datadir='/var/lib/mysql' --user=mysql &
sleep 20
# 初始化设置数据库
mysql_secure_installation <<'EOF'

y
rootpass
rootpass
y
n
y
y
EOF

# 添加数据库用户 root@% ，密码： rootpass
mysql -prootpass <<'EOF'
GRANT all privileges
    ON *.*
    TO  'root'@'%'
    IDENTIFIED BY 'rootpass';

FLUSH PRIVILEGES;
EOF

echo -e "\n====================\n for zabbix_server_mysql\n====================\n"
mysql -prootpass <<'EOF'
create database zabbix character set utf8;
grant all privileges on zabbix.* to 'zabbix'@'%' identified by '123456' with grant option;
FLUSH PRIVILEGES;
EOF
cat /create.sql | mysql -prootpass 


echo '================================='
echo 'ALL user of mariadb :'
mysql -prootpass <<'EOF'
select user,host from mysql.user;
EOF

