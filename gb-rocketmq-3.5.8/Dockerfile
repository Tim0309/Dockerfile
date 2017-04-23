# Start from a Java image.
FROM hub:5000/centos-jre8

# Rocketmq version
ENV ROCKETMQ_VERSION  4.0.0-incubating
# Rocketmq home
ENV ROCKETMQ_HOME  /usr/local/rocketmq


ENV PATH /usr/local/rocketmq/bin:$PATH

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


WORKDIR ${ROCKETMQ_HOME}
RUN set -ex \
    && curl -SL https://github.com/alibaba/RocketMQ/archive/v3.5.8.tar.gz \
        -o rocketmq.tar.gz \
    && tar xf rocketmq.tar.gz  --strip-components=1 \
    && chmod +x bin/* sbin/* \
    \
    && yum install -y git  \
    && sh install.sh \
    \
    && rm -f rocketmq.tar.gz \
    && yum remove -y git \
    && yum clean all


CMD [ "mqbroker" ]
