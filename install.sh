#!/bin/bash

# 参数
PROTOCOL=$1           # shadowsocks、vmess、trojan等
REMOTE=$2             # 远程地址及端口，如 103.180.28.134:16589
LISTEN_PORT=$3        # 本地监听端口，如 16589
ENABLE_TLS=$4         # true/false

if [[ -z "$PROTOCOL" || -z "$REMOTE" || -z "$LISTEN_PORT" || -z "$ENABLE_TLS" ]]; then
  echo "Usage: bash install.sh <protocol> <remote_ip:port> <listen_port> <tls_enabled:true|false>"
  exit 1
fi

echo "👉 开始安装 Realm..."

# 下载 Realm 二进制 (示例用静态链接，实际请替换为最新版本下载地址)
REALM_BIN_URL="https://github.com/MetaCubeX/realm/releases/latest/download/realm-linux-amd64"
mkdir -p /usr/local/bin
curl -L $REALM_BIN_URL -o /usr/local/bin/realm
chmod +x /usr/local/bin/realm

echo "✅ Realm 安装完成"

# 生成配置文件
mkdir -p /etc/realm

cat > /etc/realm/config.toml <<EOF
[network]
no_tcp = false
use_udp = true

[[endpoints]]
listen = "0.0.0.0:${LISTEN_PORT}"
remote = "${REMOTE}"
protocol = "${PROTOCOL}"

[security.tls]
enabled = ${ENABLE_TLS}
insecure = true
EOF

echo "📁 配置文件生成成功：/etc/realm/config.toml"

# 写 systemd 服务
cat > /etc/systemd/system/realm.service <<EOF
[Unit]
Description=Realm Proxy Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/realm -c /etc/realm/config.toml
Restart=on-failure
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

echo "🔧 设置 systemd 服务..."

systemctl daemon-reload
systemctl enable realm
systemctl restart realm

echo "✅ Realm 服务已启动并设置开机自启"

systemctl status realm --no-pager
