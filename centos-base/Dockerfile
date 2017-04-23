FROM centos:latest

# set $LANG
ENV "LANG=en_US.UTF-8"

# set time zone
ENV TIME_ZONE Asia/Shanghai
RUN set -ex \
    && ln -sfv  /usr/share/zoneinfo/${TIME_ZONE}  /etc/localtime

# install tools
RUN set -ex \
    \
    && echo 'PS1="[\[\e[31m\]\u@\[\e[36m\]\h \w]\$\[\e[m\]"' >> ~/.bashrc \
    \
    && yum install -y \
        iproute net-tools telnet nmap nmap-ncat bind-utils \
        vim unzip \
        traceroute mlocate sysstat \
    && yum clean all

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.10 
RUN set -x \
    && gosu_URL='https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64' \
    && gosu_ASC='https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64.asc' \
    \
    && curl -SL ${gosu_URL} -o /usr/local/bin/gosu \
    && curl -SL ${gosu_ASC} -o /usr/local/bin/gosu.asc \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net \
        --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true

# Add Tini
ENV TINI_VERSION v0.14.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# systemd for centos 7
# if `docker run` ,  '-v /sys/fs/cgroup:/sys/fs/cgroup:ro'
RUN (cd /lib/systemd/system/sysinit.target.wants/; \
        for i in *; do \
            [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; \
        done);\
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
#CMD ["/usr/sbin/init"]


