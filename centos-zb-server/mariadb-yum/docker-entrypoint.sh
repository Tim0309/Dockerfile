#!/bin/sh

set -e

zabbix_agentd -c /etc/zabbix/zabbix_agentd.conf
zabbix_server_mysql -c /etc/zabbix/zabbix_server.conf

mysqld_safe --datadir=${data_DIR} &

httpd

exec "$@"
