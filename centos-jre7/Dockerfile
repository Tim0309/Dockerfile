FROM hub:5000/centos-zb

RUN set -ex; \
    yum install -y java-1.7.0-openjdk-devel \
    && yum clean all \
    \
    && JAVA_HOME=`dirname $(dirname $(readlink $(readlink  $(which java))))`
    
ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-1.7.0.131-2.6.9.0.el7_3.x86_64/jre
ENV RESERVED_MEGABYTES 512
#ENV JAVA_OPTS -Xms256m -Xmx512m
