FROM centos:7

ENV LOR_VERSION="v0.3.4"
ENV ORANGE_VERSION="v0.7.2"
ENV ORANGE_PATH="/usr/local/orange"
ENV ENTRYPOINT="docker-entrypoint.sh"

COPY ${ENTRYPOINT} /usr/bin/${ENTRYPOINT}

ADD https://github.com/sumory/lor/archive/${LOR_VERSION}.tar.gz /tmp
ADD https://github.com/imocat/orange/archive/${ORANGE_VERSION}.tar.gz /tmp

RUN date \
&& chmod +x /usr/bin/${ENTRYPOINT} \
&& useradd www \
&& yum update -y \
&& yum-config-manager --add-repo https://openresty.org/yum/cn/centos/OpenResty.repo \
&& yum install -y epel-release \
&& yum install -y openresty openresty-resty openresty-opm \
&& yum install -y make net-tool luarocks lua lua-devel gcc g++ \
&& yum clean all \
&& ln -s /usr/local/openresty/nginx/susr/bin/nginx /usr/local/usr/bin/nginx \
&& yum clean all \
&& cd /tmp \
&& sh -c 'if [[ -f "${LOR_VERSION}.tar.gz" ]];then tar xf ${LOR_VERSION}.tar.gz;fi;' \
&& sh -c 'if [[ -f "${ORANGE_VERSION}.tar.gz" ]];then tar xf ${ORANGE_VERSION}.tar.gz;fi;' \
&& cd /tmp/lor-${LOR_VERSION/v/} && make install \
&& cd /tmp/orange-${ORANGE_VERSION/v/} \
&& echo "return \"${ORANGE_VERSION/v/}\"" > orange/version.lua \
&& make install \
&& luarocks install lua-resty-http \
&& luarocks install lua-resty-dns-client \
&& luarocks install luasocket \
&& rm -rf /tmp/*

EXPOSE 7777 8888 9999

ENTRYPOINT "/usr/bin/${ENTRYPOINT}"