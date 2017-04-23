FROM hub:5000/centos-zb-server

ENV data_DIR /var/lib/mysql
# yum install    
RUN set -ex \
    && yum install -y mariadb-server \
    \
    && yum clean all
# mysql_init_db
COPY init-mariadb.sh /
# import zabbix_server_db 
COPY create.sql  /

RUN set -ex \
    && mysql_install_db \
        --basedir=/usr/ \
        --datadir=${data_DIR} \
        --user=mysql \
    \
    && sed -i '/\[mysqld_safe\]/iinnodb_file_per_table = ON' /etc/my.cnf \
    && sed -i '/\[mysqld_safe\]/iskip_name_resolve = ON' /etc/my.cnf \
    \
    && systemctl enable mariadb.service \
    \
    && /init-mariadb.sh 

EXPOSE 3306
VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /
# zabbix for chinese
COPY  UTF-8 /
RUN localedef -f /UTF-8 -i zh_CN /usr/lib/locale/zh_CN.UTF-8
ENV LANG zh_CN.UTF-8
ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD ["/usr/sbin/init"]
