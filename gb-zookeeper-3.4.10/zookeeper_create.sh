#!/bin/bash

# ==================== variable ====================
# docker service信息，格式：
# 服务名:zoo_ID:节点主机名
REDIS_HOST=" \
zoo_001:1:D1 \
zoo_002:2:D2 \
zoo_003:3:D3 \
"

ZOO_SERVERS="server.1=zoo_001:2888:3888 server.2=zoo_001:2888:3888 server.3=zoo_003:2888:3888"

IMAGE="hub:5000/gb-zookeeper:3.4.10"
NET_NAME="gb-net"

# ==================== function ====================
# 清除旧容器，容器命名以 redis_ 开头
clean_SERVICE(){
    docker service rm  $(docker service ls | grep -io "zoo_[^ ]*")
    docker system prune -f
}

create_SERVICE(){
    docker service create \
        --name $1 \
        --network ${NET_NAME} \
        -e ZOO_MY_ID=$2 \
        -e ZOO_SERVERS="$ZOO_SERVERS"  \
        --constraint  "node.hostname == $3" \
        --restart-condition any \
        ${IMAGE}
}


# ==================== __main__ ====================
echo -e "\e[34m[清除原有service...]\e[0m"
clean_SERVICE

echo -e "\e[34m[正在创建service...]\e[0m"
sleep 2
for i in  $REDIS_HOST; do
    service_NAME=`echo $i | cut -d: -f1`
    ZOO_MY_ID=`echo $i | cut -d: -f2`
    node_NAME=`echo $i | cut -d: -f3`
    create_SERVICE "$service_NAME" "$ZOO_MY_ID" "$node_NAME"
    sleep 5
done

echo -e "\e[34m[zookeeper service创建完成...]\e[0m\n"
sleep 5
