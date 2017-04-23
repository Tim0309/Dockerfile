#!/bin/sh

set -e

zabbix_agentd -c /var/zabbix/zabbix_agentd.conf

zabbix_server_mysql -c /etc/zabbix/zabbix_server.conf

/usr/local//bin/mysqld_safe --datadir='/var/mysql/data' &
httpd

exec "$@"
