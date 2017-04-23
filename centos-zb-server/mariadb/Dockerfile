FROM hub:5000/centos-zb-server


ENV db_user='mysql' \
    db_userid='3306' \
    db_version='mariadb-5.5.53'
    
RUN set -ex \
    ;  [[ -z ${LC_ALL} ]] && export LC_ALL=C \
    \
    ; useradd --uid ${db_userid} -s /sbin/nologin -d /var/mysql ${db_user} \
    \
# 编译环境
    && yum install -y \
        cmake make gcc gcc-c++ \
        initscripts chkconfig \
    && yum install -y \
        ncurses-devel openssl-devel \
        zlib-dev jemalloc-devel bison libevent-devel \
    \
# 下载解压
    && compile_DIR=`mktemp -d` \
    && curl -SL https://downloads.mariadb.org/interstitial/mariadb-5.5.53/source/${db_version}.tar.gz \
        -o mariadb.tar.gz \
    && tar xf mariadb.tar.gz -C $compile_DIR  --strip-components=1 \
    \
# 编译安装
    && cd $compile_DIR \
    && cmake \
        -DDEFAULT_CHARSET=utf8 \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DDEFAULT_COLLATION=utf8_general_ci  \
        -DENABLED_LOCAL_INFILE=1 \
        -DEXTRA_CHARSETS=all \
        -DMYSQL_DATADIR=/var/mysql/data \
        -DMYSQL_TCP_PORT=3306 \
        -DMYSQL_UNIX_ADDR=/var/mysql/mysql.sock \
        -DWITH_ARCHIVE_STORAGE_ENGINE=1 \
        -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
        -DWITH_EXTRA_CHARSETS=1 \
        -DWITH_INNOBASE_STORAGE_ENGINE=1 \
        -DWITH_LIBWRAP=0 \
        -DWITH_MYISAM_STORAGE_ENGINE=1 \
        -DWITH_PARTITION_STORAGE_ENGINE=1 \
        -DWITH_READLINE=1 \
        -DWITH_SSL=system \
        -DWITH_XTRADB_STORAGE_ENGINE=1 \
        -DWITH_ZLIB=system \
    && make -j4 \
    && make install \
    \
# 清理
    && cd \
    && rm -rf /mariadb.tar.gz $compile_DIR \
    && yum remove -y \
        cmake make gcc gcc-c++ \
    && yum clean all

COPY create.sql docker-entrypoint.sh init-mariadb.sh my.cnf /

RUN set -ex \
    && gosu mysql mkdir -p /var/mysql/data \
    && /usr/local/scripts/mysql_install_db \
        --basedir=/usr/local/ \
        --datadir=/var/mysql/data \
        --user=mysql \
    && mv -f /my.cnf  /etc/my.cnf 

RUN set -ex ;  /init-mariadb.sh

EXPOSE 80 3306
ENTRYPOINT [ "/docker-entrypoint.sh" ]

RUN mv -f {/var,/etc}/zabbix/zabbix_server.conf \
    && systemctl enable  zabbix-server

CMD ["/usr/sbin/init"]
