#!/bin/sh

set -e

sed -i "s@\$zb_Hostname@$zb_Hostname@g"    $zb_AgentConfDir
sed -i "s@\$zb_Server@$zb_Server@g"        $zb_AgentConfDir
sed -i "s@\$zb_AgentPort@$zb_AgentPort@g"  $zb_AgentConfDir
sed -i "s@\$zb_SerActive@$zb_SerActive@g"  $zb_AgentConfDir
zabbix_agentd -c  $zb_AgentConfDir



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
