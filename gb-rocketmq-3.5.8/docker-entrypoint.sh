#!/bin/sh

set -e

zabbix_agentd -c /var/zabbix/zabbix_agentd.conf

cat <<EOF > /rocketmq.conf
brokerClusterName=DefaultCluster
deleteWhen=04
fileReservedTime=48
flushDiskType=SYNC_FLUSH
autoCreateTopicEnable=true
#listenPort=
#haListenPort=
maxMessageSize=524288000

brokerId=${brokerId}
brokerRole=${brokerRole}
brokerName=${brokerName}
namesrvAddr=${namesrvAddr}
EOF

exec "$@"
