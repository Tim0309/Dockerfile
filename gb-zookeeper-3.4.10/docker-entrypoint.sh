#!/bin/sh

set -e

sed -i "s@\$zb_Hostname@$zb_Hostname@g"    $zb_AgentConfDir
sed -i "s@\$zb_Server@$zb_Server@g"        $zb_AgentConfDir
sed -i "s@\$zb_AgentPort@$zb_AgentPort@g"  $zb_AgentConfDir
sed -i "s@\$zb_SerActive@$zb_SerActive@g"  $zb_AgentConfDir
zabbix_agentd -c  $zb_AgentConfDir


# Generate the config only if it doesn't exist
if [ ! -f "$ZOO_CONF_DIR/zoo.cfg" ]; then
    CONFIG="$ZOO_CONF_DIR/zoo.cfg"

    echo "clientPort=$ZOO_PORT" >> "$CONFIG"
    echo "dataDir=$ZOO_DATA_DIR" >> "$CONFIG"
    echo "dataLogDir=$ZOO_DATA_LOG_DIR" >> "$CONFIG"

    echo "tickTime=$ZOO_TICK_TIME" >> "$CONFIG"
    echo "initLimit=$ZOO_INIT_LIMIT" >> "$CONFIG"
    echo "syncLimit=$ZOO_SYNC_LIMIT" >> "$CONFIG"

    for server in $ZOO_SERVERS; do
        echo "$server" >> "$CONFIG"
    done
fi

# Write myid only if it doesn't exist
if [ ! -f "$ZOO_DATA_DIR/myid" ]; then
    echo "${ZOO_MY_ID:-1}" > "$ZOO_DATA_DIR/myid"
fi

# Allow the container to be started with `--user`
if [ "$1" = 'zkServer.sh' -a "$(id -u)" = '0' ]; then
    chown -R "$ZOO_USER" "$ZOO_DATA_DIR" "$ZOO_DATA_LOG_DIR"
    exec gosu  "$ZOO_USER"  "$@"
fi

exec "$@"
