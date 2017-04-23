FROM hub:5000/centos-zb

ENV REDIS_VERSION=3.2.8 \
    REDIS_USER=redis \
    REDIS_UID=996
# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN set -ex \
    && useradd -r -u $REDIS_UID  $REDIS_USER

# for redis-sentinel see: http://redis.io/topics/sentinel
RUN set -ex \
    \
    && Tools=' \
        gcc \
        gcc-c++ \
        make \
    ' \
    && REDIS_URL='http://download.redis.io/releases/redis-3.2.8.tar.gz' \
    && REDIS_SHA1='6780d1abb66f33a97aad0edbe020403d0a15b67f' \
    \
    && yum install -y $Tools tcl-devel ruby-devel rubygems-devel ca-certificates \
    \
    && curl  -o redis.tar.gz -SL "$REDIS_URL" \
    && echo "$REDIS_SHA1 redis.tar.gz" | sha1sum -c - \
    && mkdir -p /usr/src/redis \
    && tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
    && rm redis.tar.gz \
    \
# Disable Redis protected mode [1] as it is unnecessary in context
# of Docker. Ports are not automatically exposed when running inside
# Docker, but rather explicitely by specifying -p / -P.
# [1] https://github.com/antirez/redis/commit/edd4d555df57dc84265fdfb4ef59a4678832f6da
    && grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 1$' /usr/src/redis/src/server.h \
    && sed -ri 's!^(#define CONFIG_DEFAULT_PROTECTED_MODE) 1$!\1 0!' /usr/src/redis/src/server.h \
    && grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 0$' /usr/src/redis/src/server.h \
# for future reference, we modify this directly in the source instead of just supplying a default configuration flag because apparently "if you specify any argument to redis-server, [it assumes] you are going to specify everything"
# see also https://github.com/docker-library/redis/issues/4#issuecomment-50780840
# (more exactly, this makes sure the default behavior of "save on SIGTERM" stays functional by default)
    \
    && make -C /usr/src/redis \
    && make -C /usr/src/redis install \
    \
# install redis-trib.rb redis-stat
    && mv /usr/src/redis/src/redis-trib.rb /bin/ \
    && chmod +x /bin/redis-trib.rb \
    && gem install redis redis-stat \
    \
# redis-trib.rb 免交互
    && sed -i '/yes_or_die.msg/a return if ENV["QUIET_MODE"] == "1"' /bin/redis-trib.rb \
    \
    && rm -r /usr/src/redis \
    && yum remove -y $Tools \
    && yum clean all

