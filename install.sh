#!/bin/bash

set -e

# 读取参数
PROTOCOL=${1:-vmess}
REMOTE=${2:-"1.2.3.4:10000"}
LISTEN_PORT=${3:-443}
ENABLE_TLS=${4:-false}

echo "👉 安装 Realm 中..."
cd /tmp
REPO_URL="https://github.com/zhboner/realm/releases/latest/download"
BIN_NAME="realm-x86_64-unknown-linux-gnu.tar.gz"

wget -q "${REPO_URL}/${BIN_NAME}" -O realm.tar.gz
tar -xzf realm.tar.gz
chmod +x realm
mv realm /usr/local/bin/

echo "✅ Realm 安装完成"

echo "📁 生成配置文件..."
mkdir -p /etc/realm
cat > /etc/realm/config.json <<EOF
{
  "log_level": "info",
  "listen": "0.0.0.0:${LISTEN_PORT}",
  "remote": "${REMOTE}",
  "tls": {
    "enabled": ${ENABLE_TLS},
    "insecure": true
  },
  "transport": "tcp",
  "protocol": "${PROTOCOL}"
}
EOF

echo "✅ 配置文件已生成：/etc/realm/config.json"

echo "🔧 设置 systemd 服务..."
cat > /etc/systemd/system/realm.service <<EOF
[Unit]
Description=Realm Proxy Service
After=network.target

[Service]
ExecStart=/usr/local/bin/realm -c /etc/realm/config.json
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable --now realm

echo "✅ Realm 已启动并设置为开机自启"
systemctl status realm --no-pager
