#!/bin/sh

set -e

sed -i "s@\$zb_Hostname@$zb_Hostname@g"    $zb_AgentConfDir
sed -i "s@\$zb_Server@$zb_Server@g"        $zb_AgentConfDir
sed -i "s@\$zb_AgentPort@$zb_AgentPort@g"  $zb_AgentConfDir
sed -i "s@\$zb_SerActive@$zb_SerActive@g"  $zb_AgentConfDir
zabbix_agentd -c  $zb_AgentConfDir

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
    set -- redis-server "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
    chown -R redis .
    chown -R redis /var/redis/
    exec gosu redis  "$@"
fi

exec "$@"
