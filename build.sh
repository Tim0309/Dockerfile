#!/bin/bash

ALL=" \
centos-base \
centos-zb \
  centos-jre8 \
    gb-rocketmq-4.0.0 \
    gb-tomcat-jre8-7.0.67 \
    gb-zookeeper-3.4.10 \
  centos-redis \
    gb-redis-3.2.8 \
  gb-nginx-1.11.13 \
  gb-postgres-9.6.2 \
  centos-zb-server \
"

if [[  $# -ne 0 ]];then
    LIST="$@"
else
    LIST="$ALL"
fi

for i in $LIST;do
    if [ -d ./$i ];then
        clear
        echo -e "\e[31m=========================================================================="
        echo -e "\n\n 正在创建镜像 < hub:5000/${i} > ......\n请稍后......\n\n"
        echo -e "==========================================================================\e[m"
        sleep 3
        ( cd ./$i;./build.sh ) || exit
    else
        echo -e  "\e[31m$i: No such  directory\e[m"
    fi
done

docker system prune -f
