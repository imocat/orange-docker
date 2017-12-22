FROM orange:openresty

ENV LOR_VERSION="v0.3.4"
ENV ORANGE_VERSION="v0.7.3"

ENV ORANGE_PATH="/usr/local/orange"
ENV ENTRYPOINT="/usr/local/bin/docker-entrypoint.sh"

ADD docker-entrypoint.sh ${ENTRYPOINT}

ADD https://github.com/sumory/lor/archive/${LOR_VERSION}.tar.gz /tmp
ADD https://github.com/imocat/orange/archive/${ORANGE_VERSION}.tar.gz /tmp

RUN date \
&& chmod +x ${ENTRYPOINT} \
&& cd /tmp \
&& tar xf ${LOR_VERSION}.tar.gz \
&& tar xf ${ORANGE_VERSION}.tar.gz \
&& cd /tmp/lor-${LOR_VERSION/v/} && make install \
&& cd /tmp/orange-${ORANGE_VERSION/v/} && make install \
&& luarocks install lua-resty-http \
&& luarocks install lua-resty-dns-client \
&& luarocks install luasocket \
&& rm -rf /tmp

EXPOSE 7777 8888 9999

ENTRYPOINT ${ENTRYPOINT}