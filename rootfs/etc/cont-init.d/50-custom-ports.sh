#!/bin/bash

# 设置默认端口值
HTTP_PORT=${HTTP_PORT:-8080}
HTTPS_PORT=${HTTPS_PORT:-4443}
MANAGEMENT_PORT=${MANAGEMENT_PORT:-8181}

echo "[Custom Ports] Configuring ports: HTTP=$HTTP_PORT, HTTPS=$HTTPS_PORT, Management=$MANAGEMENT_PORT"

# 确保目录存在
mkdir -p /config/nginx

# 如果默认配置文件存在，复制一份
if [ -f /app/templates/default.conf ]; then
    echo "[Custom Ports] Updating default.conf template with custom ports"
    sed -i "s/listen 80;/listen $HTTP_PORT;/g" /app/templates/default.conf
    sed -i "s/listen 443 ssl http2;/listen $HTTPS_PORT ssl http2;/g" /app/templates/default.conf
fi

# 更新nginx主配置文件中的端口设置
if [ -f /config/nginx/nginx.conf ]; then
    echo "[Custom Ports] Updating nginx.conf with custom ports"
    sed -i "s/listen 80;/listen $HTTP_PORT;/g" /config/nginx/nginx.conf
    sed -i "s/listen 443 ssl http2;/listen $HTTPS_PORT ssl http2;/g" /config/nginx/nginx.conf
    sed -i "s/listen 8181;/listen $MANAGEMENT_PORT;/g" /config/nginx/nginx.conf
fi

# 更新管理界面的反向代理配置
if [ -f /config/nginx/proxy_host.conf ]; then
    echo "[Custom Ports] Updating proxy_host.conf with custom ports"
    sed -i "s/listen 80;/listen $HTTP_PORT;/g" /config/nginx/proxy_host.conf
    sed -i "s/listen 443 ssl http2;/listen $HTTPS_PORT ssl http2;/g" /config/nginx/proxy_host.conf
fi

# 更新默认配置（如果存在）
if [ -f /rootfs/defaults/production.json ]; then
    echo "[Custom Ports] Updating production.json with custom management port"
    sed -i "s/\"port\": 8181/\"port\": $MANAGEMENT_PORT/g" /rootfs/defaults/production.json
fi

# 更新应用的默认配置文件
if [ -f /config/production.json ]; then
    echo "[Custom Ports] Updating /config/production.json with custom management port"
    sed -i "s/\"port\": 8181/\"port\": $MANAGEMENT_PORT/g" /config/production.json
fi

echo "[Custom Ports] Port configuration completed"
