FROM hub:5000/centos-zb

#ENV zb_REPO='http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm'
ENV zb_REPO='http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm'
RUN set -ex \
    && yum install -y ${zb_REPO} \
    && yum makecache \
    && yum install -y \
        zabbix-server-mysql \
        zabbix-agent \
        zabbix-sender \
        zabbix-web-mysql \
        zabbix-web.noarch \
    \
    && rm -f /etc/yum.repos.d/zabbix.repo \
    ;  yum clean all

RUN set -ex \
    && sed -i '/\[Date\]/adate.timezone = Asia/Shanghai' /etc/php.ini \
    && echo 'ServerName www.example.com:80' >> /etc/httpd/conf/httpd.conf \
    && sed -i '/.*Chinese.*zh_CN.*/s@false@true@g'  /usr/share/zabbix/include/locales.inc.php \
    && sed -i '/ZBX_GRAPH_FONT_NAME/s@graphfont@msyh@g' /usr/share/zabbix/include/defines.inc.php \
    \
    ;  systemctl enable httpd.service \
    ;  systemctl enable zabbix-server.service

COPY zabbix_server.conf /etc/zabbix/
COPY msyh.ttf /usr/share/zabbix/

EXPOSE 80

# yum install mariadb-service    
ENV data_DIR /var/lib/mysql
RUN set -ex \
    && yum install -y mariadb-server \
    \
    && yum clean all
# mysql_init_db
COPY init-mariadb.sh  UTF-8 create.sql  /

RUN set -ex \
    && localedef -f /UTF-8 -i zh_CN /usr/lib/locale/zh_CN.UTF-8 \
    \
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
ENV LANG zh_CN.UTF-8
ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD ["/usr/sbin/init"]
