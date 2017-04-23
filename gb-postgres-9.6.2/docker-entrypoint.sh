#!/bin/sh

set -e

sed -i "s@\$zb_Hostname@$zb_Hostname@g"    $zb_AgentConfDir
sed -i "s@\$zb_Server@$zb_Server@g"        $zb_AgentConfDir
sed -i "s@\$zb_AgentPort@$zb_AgentPort@g"  $zb_AgentConfDir
sed -i "s@\$zb_SerActive@$zb_SerActive@g"  $zb_AgentConfDir
zabbix_agentd -c  $zb_AgentConfDir

if [ ! -f "/var/data/postgres/postgresql.conf" ];then
    gosu postgres initdb -D /var/data/postgres
    #gosu postgres pg_ctl -D /var/data/postgres -l logfile start
#    gosu postgres cp -f /pg_hba.conf /postgresql.conf /var/data/postgres/
fi

# allow the container to be started with `--user`
if [ "$1" = 'postgres' -a "$(id -u)" = '0' ]; then
    chown -R postgres .
    exec gosu postgres   "$@"
fi

exec "$@"
