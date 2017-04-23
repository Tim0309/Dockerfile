FROM hub:5000/centos-jre8

ENV CATALINA_HOME=/usr/local/tomcat \
    PATH=/usr/local/tomcat/bin/:$PATH \
    tomcat_VERSION='7.0.67' \
    JAVA_OPTS='-Xms512m -Xmx1024m -Xss1024K '

WORKDIR ${CATALINA_HOME}

RUN set -ex \
    && tomcat_MD5='fa66329388f85c08e8d6c12ceb8b2ca3' \
    && curl -SL http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.77/bin/apache-tomcat-7.0.77.tar.gz \
        -o tomcat.tar.gz \
    && echo "${tomcat_MD5}" tomcat.tar.gz | md5sum -c \
    \
    && tar xf tomcat.tar.gz -C . --strip-components=1 \
    \
    && rm -f bin/*.bat \
    && rm -f tomcat.tar.gz \
    \
    && chmod +x bin/* \
    && ln -sv ${CATALINA_HOME}/bin/{startup.sh,tomcat-start} \
    && ln -sv ${CATALINA_HOME}/bin/{shutdown.sh,tomcat-stop} \
    && sed -i  's@"$CATALINA_BASE"/logs/catalina.out@/dev/null@g' bin/catalina.sh

EXPOSE 8080
VOLUME /usr/local/tomcat/webapps/ROOT
COPY docker-entrypoint.sh /
ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD [ "catalina.sh", "run" ]
