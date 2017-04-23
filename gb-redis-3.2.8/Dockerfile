FROM hub:5000/centos-redis

RUN mkdir -p /var/redis/{conf,log}  \
    && chown -R redis:redis /var/redis/ 

COPY docker-entrypoint.sh /
COPY redis.conf /var/redis/conf/

VOLUME /var/redis/log

WORKDIR /var/redis

ENTRYPOINT ["/tini", "--", "/docker-entrypoint.sh"]

CMD [ "redis-server","/var/redis/conf/redis.conf" ]
