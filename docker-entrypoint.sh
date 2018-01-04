#!/usr/bin/env bash

export ORANGE_CONF="${ORANGE_PATH}/conf/orange.conf"
export NGINX_CONF="${ORANGE_PATH}/conf/nginx.conf"
export ORANGE_API_USERNAME="${ORANGE_API_USERNAME-u$(date +"%s")}"
export ORANGE_API_PASSWORD="${ORANGE_API_PASSWORD-p$(date +"%s")}"

echo "初始化"

# 配置 ORANGE 数据库配置
if [[ "${ORANGE_DB_NAME}" != "" ]]; then
    # set database connection
    sed -i "s/\"host\": \"127.0.0.1\"/\"host\": \"${ORANGE_DB_HOST}\"/g" ${ORANGE_CONF}
    sed -i "s/\"port\": \"3306\"/\"port\": \"${ORANGE_DB_PORT}\"/g" ${ORANGE_CONF}
    sed -i "s/\"database\": \"orange\"/\"database\": \"${ORANGE_DB_NAME}\"/g" ${ORANGE_CONF}
    sed -i "s/\"user\": \"root\"/\"user\": \"${ORANGE_DB_USER}\"/g" ${ORANGE_CONF}
    sed -i "s/\"password\": \"\"/\"password\": \"${ORANGE_DB_PWD}\"/g" ${ORANGE_CONF}
fi

# 开启授权
sed -i "s/\"auth\": false/\"auth\": true/g" ${ORANGE_CONF}
sed -i "s/\"auth_enable\": false/\"auth_enable\": true/g" ${ORANGE_CONF}

# 设置 API 用户和密码
sed -i "s/api_username/${ORANGE_API_USERNAME}/" ${ORANGE_CONF}
sed -i "s/api_password/${ORANGE_API_PASSWORD}/" ${ORANGE_CONF}

# nginx 工作线程数
if [[ "${NGINX_WORKER_PROCESSES}" != "" ]]
then
    processor=${NGINX_WORKER_PROCESSES}
else
    processor=$(cat /proc/cpuinfo | grep processor | wc -l)
fi

sed -i "s/worker_processes  4;/user www www;\nworker_processes  ${processor};\ndaemon  on;/g" ${NGINX_CONF}
sed -i "s/listen       80;/listen       8888;/g" ${NGINX_CONF}

# 设置 nginx 的 DNS 解析服务器
if [[ "${NGINX_DNS}" != "" ]]
then
    sed -i "s/resolver 114.114.114.114;/resolver ${NGINX_DNS};/g" ${NGINX_CONF}
fi

# 修改日志文件命名
sed -i "s/\/logs\//\/logs\/$(hostname)-/g" ${NGINX_CONF}

# 设置 lua 环境
echo "设置环境"
$(luarocks path --bin)

echo "启动 ORANGE"

# 启动 orange
/usr/local/bin/orange start

# 注册节点
echo "注册 ORANGE 节点"
/usr/local/bin/orange register

echo "监控日志文件"

tail -f ${ORANGE_PATH}/logs/access.log