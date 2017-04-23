FROM hub:5000/centos-zb

ENV PGUSER=postgres \
    PGPORT=5432 \
    PGUID=1000 \
    PGUSER_HOME='/var/data'

ENV PATH=/usr/local/postgres/bin:$PATH \
    PGDATA=/var/data/postgres

COPY sysctl_conf.sh /
RUN /sysctl_conf.sh

# create USER
RUN set -ex \
    && useradd -u $PGUID  -d /var/data -m  $PGUSER \
    \
    && su - postgres -c 'mkdir -p /var/data/{postgres,backup,xlog_archive}' \
    \
    && echo "$PGUSER    ALL=(ALL)  NOPASSWD:    ALL" >> /etc/sudoers

# compile & install pgSQL
RUN set -ex \
    && build_DEV=' gcc make \
        perl-ExtUtils-Embed readline-devel \
        zlib-devel pam-devel libxml2-devel \
        libxslt-devel openldap-devel openssl-devel\
        tcl-devel python-devel \
        ' \
    && pgsql_URL='https://ftp.postgresql.org/pub/source/v9.6.2/postgresql-9.6.2.tar.gz' \
    && pgsql_MD5='https://ftp.postgresql.org/pub/source/v9.6.2/postgresql-9.6.2.tar.gz.md5' \
    \
    && yum install -y $build_DEV \
    && curl -SL $pgsql_URL -o postgresql-9.6.2.tar.gz \
    && curl $pgsql_MD5 | md5sum -c \
    \
    && compile_DIR=`mktemp -d` \
    && tar xf postgresql-9.6.2.tar.gz -C $compile_DIR --strip-components=1 \
    \
    && rm -f postgresql-9.6.2.tar.gz \
    \
    && cd $compile_DIR \
    && ./configure \
        --prefix=/usr/local/postgres \
        --with-pgport=5432 \
        --with-perl \
        --with-tcl \
        --with-python \
        --with-openssl \
        --with-pam \
        --with-libxml \
        --with-libxslt \
        --enable-thread-safety \
        --with-wal-blocksize=16 \
        --with-blocksize=8 \
    && gmake world \
    && gmake install-world \
    \
    && cd \
    && rm -rf $compile_DIR \
    && yum remove -y gcc make \
    && yum clean all

VOLUME /var/data 
EXPOSE 5432
WORKDIR /var/data/

#COPY pg_hba.conf postgresql.conf /
COPY docker-entrypoint.sh /
ENTRYPOINT ["/tini", "--", "/docker-entrypoint.sh"]

CMD [ "postgres" ]

