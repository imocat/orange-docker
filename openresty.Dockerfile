FROM centos:7

RUN date \

&& yum update -y \
&& yum-config-manager --add-repo https://openresty.org/yum/cn/centos/OpenResty.repo \
&& yum install -y epel-release \
&& yum install -y openresty openresty-resty openresty-opm \
&& yum install -y make net-tool luarocks lua lua-devel gcc g++ \
&& yum clean all \

&& ln -s /usr/local/openresty/nginx/sbin/nginx /usr/local/bin/nginx \

&& yum clean all \
&& rm -rf /tmp/* \

&& useradd www