FROM hub:5000/centos-zb

ENV NGINX_USER='nginx' \
    NGINX_UID='800'

RUN set -ex \
    && useradd -u ${NGINX_UID} -d /var/cache/nginx  ${NGINX_USER} 

ENV NGINX_VERSION=1.11.13 \
    NGINX_MD5='1d8310d4d9f6eb3ed97463cc659178a4'

RUN set -ex \
    \
    && yum install -y \
        gcc \
        make \
        openssl-devel \
        pcre-devel \
        zlib-devel \
        libxslt-devel \
        gd-devel \
        perl-devel \
        geoip-devel \
        perl-ExtUtils-Embed \
        perl-ExtUtils-CBuilder \
    \
    && curl -fSL http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz \
        -o nginx.tar.gz \
    && echo $NGINX_MD5 nginx.tar.gz | md5sum -c \
    \
    && mkdir -p /usr/src/nginx \
    && tar -xzf nginx.tar.gz -C /usr/src/nginx --strip-components=1 \
    && rm -f nginx.tar.gz \
    \
    && cd /usr/src/nginx \
    && ./configure --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --user=$NGINX_USER \
        --group=$NGINX_USER \
        --with-http_ssl_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_stub_status_module \
        --with-http_auth_request_module \
        --with-http_xslt_module=dynamic \
        --with-http_image_filter_module=dynamic \
        --with-http_geoip_module=dynamic \
        --with-http_perl_module=dynamic \
        --with-threads \
        --with-stream \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --with-stream_realip_module \
        --with-stream_geoip_module=dynamic \
        --with-http_slice_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-compat \
        --with-file-aio \
        --with-http_v2_module \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    \
    && rm -rf /etc/nginx/html/ \
    && mkdir /etc/nginx/conf.d/ \
    && mkdir -p /usr/share/nginx/html/ \
    && cd / \
    && rm -rf /usr/src/nginx \
    && yum remove -y gcc make \
    && yum clean all

HEALTHCHECK --interval=5s --timeout=3s \
      CMD curl -fs http://localhost/ || exit 1

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf

COPY docker-entrypoint.sh /
EXPOSE 80 443
VOLUME /etc/nginx/ /var/log/nginx/ /usr/share/nginx/html/

ENTRYPOINT ["/tini", "--", "/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

