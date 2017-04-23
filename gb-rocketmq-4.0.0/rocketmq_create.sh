#!/bin/bash

# ==================== variable ====================
rocketmq_namesrv='rocketmq_namesrv'
# docker service信息，格式：
# 服务名:节点主机名
broker_NAME=" \
D1_1:D1 \
D2_2:D2 \
D3_3:D3 \
"

IMAGE="hub:5000/gb-rocketmq"
NET_NAME="gb-net"


mqbroker_CMD="mqbroker -c /rocketmq.conf"

# ==================== function ====================
# 清除旧容器，容器命名以 rocketmq_ 开头
clean_SERVICE(){
    docker service rm  $(docker service ls | grep -io "rocketmq_[^ ]*")
    echo y | docker system prune
}

create_NETWORK(){
    docker network create \
        -d overlay \
        --attachable \
        --subnet=10.10.0.0/16 \
        --gateway=10.10.0.254 \
        ${NET_NAME}
}

# 指定服务名（统一添加前缀redis_）、指定network、指定部署节点、开启 redis cluster模式，
# 各节点创建logs挂载目录   --mount type=bind,source=******,destination=****

#  /rocketmq.conf:

#  brokerName=broker-a              # 同组master 和 slave 需要同名
#  brokerId=0                       # =0 ==> master    ≠0 ==> slave
#  brokerRole=SYNC_MASTER           # SYNC_MASTER|SLAVE
#  namesrvAddr=

# Usage:  create_SERVICE  <brokerName>  <brokerId>  <brokerRole>  <container_name>   <swarm_node>
create_SERVICE(){
#    pssh -H $2 -i "mkdir -p /var/gb/logs/rocketmq_${1}"
    docker service create \
        -e brokerName=$1 \
        -e brokerId=$2 \
        -e brokerRole=$3 \
        -e namesrvAddr=${rocketmq_namesrv}:9876 \
        --name rocketmq_$4 \
        --network ${NET_NAME} \
        --constraint  "$5" \
        --restart-condition any \
        ${IMAGE} \
        ${mqbroker_CMD}
}


# ==================== __main__ ====================

echo -e "\e[34m[清除原有rocketmq service...]\e[0m"
clean_SERVICE

echo -e "\e[34m[正在创建network...]\e[0m"
sleep 5
create_NETWORK


echo -e "\e[34m[正在创建 rocketmq_namesrv...]\e[0m"
sleep 5
docker service create \
    --name ${rocketmq_namesrv} \
    --mode global \
    --restart-condition any \
    ${IMAGE} \
    mqnamesrv

echo -e "\e[34m[正在创建broker service ====> master ...]\e[0m"
sleep 5
set -ex
# Usage:  create_SERVICE  <brokerName>  <brokerId>  <brokerRole>  <container_name>   <swarm_node>
for i in  $broker_NAME; do
    create_SERVICE  ${i%%:*}  0  SYNC_MASTER  ${i%%:*}_m  "node.hostname == ${i##*:}"
done
wait

echo -e "\e[34m[正在创建broker service ====> slave ...]\e[0m"
sleep 5
for i in  $broker_NAME; do
    create_SERVICE  ${i%%:*}  1  SLAVE  ${i%%:*}_s  "node.hostname != ${i##*:}"
done


echo -e "\e[34m[rocketmq service创建完成...]\e[0m\n"

