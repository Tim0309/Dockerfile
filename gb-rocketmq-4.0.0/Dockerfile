# Start from a Java image.
FROM hub:5000/centos-jre8

# Rocketmq version
ENV ROCKETMQ_VERSION  4.0.0-incubating
# Rocketmq home
ENV ROCKETMQ_HOME  /usr/local/rocketmq

WORKDIR ${ROCKETMQ_HOME}

RUN set -ex; \
    mkdir -p /var/rocketmq/{logs,store} \
    \
    && curl https://dist.apache.org/repos/dist/release/incubator/rocketmq/${ROCKETMQ_VERSION}/rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip \
        -o rocketmq.zip \
    && unzip rocketmq.zip \
    && mv apache-rocketmq-all/* . \
    && rmdir apache-rocketmq-all  \
    && rm rocketmq.zip \
    \
    && chmod +x ${ROCKETMQ_HOME}/bin/* 

ENV PATH /usr/local/rocketmq/bin:$PATH

ENV brokerName=test \
    brokerId=0 \
    brokerRole=SLAVE \
    namesrvAddr=test \
    JAVA_OPTS="-server -Xmx1024m -Xms256m -Duser.home=/usr/local"

# install apache-maven
ENV maven_NAME=apache-maven-3.5.0-bin
ENV PATH /usr/local/apache-maven/bin:$PATH

RUN set -ex \
    && curl -SL \
        http://mirror.rise.ph/apache/maven/maven-3/3.5.0/binaries/${maven_NAME}.tar.gz \
        -o ${maven_NAME}.tar.gz \
    && mkdir -p /usr/local/apache-maven \
    && tar -xzf ${maven_NAME}.tar.gz -C /usr/local/apache-maven --strip-components=1 \
    && rm -f ${maven_NAME}.tar.gz \
    && mvn -version

COPY docker-entrypoint.sh /

VOLUME  /var/rocketmq/logs \
        /var/rocketmq/store
ENTRYPOINT ["/tini", "--", "/docker-entrypoint.sh"]

ENV MAVEN_OPTS -Xmx512m
CMD [ "mqbroker" ]
