#!/bin/bash
set -e

if [ $# -ne 4 ]; then
  echo "Error: 必须传入4个参数：协议 远程地址 远程端口 TLS开关(true/false)"
  exit 1
fi

PROTOCOL=$1
REMOTE_ADDR=$2
REMOTE_PORT=$3
TLS_ENABLED=$4

REALM_BIN="/usr/local/bin/realm"
CONFIG_DIR="/etc/realm"
CONFIG_FILE="$CONFIG_DIR/config.toml"
SERVICE_FILE="/etc/systemd/system/realm.service"

echo "👉 开始安装 Realm..."

curl -L https://github.com/MetaCubeX/realm/releases/latest/download/realm-linux-amd64 -o $REALM_BIN
chmod +x $REALM_BIN

mkdir -p $CONFIG_DIR

cat > $CONFIG_FILE <<EOF
[network]
no_tcp = false
use_udp = true

[[endpoints]]
listen = "0.0.0.0:$REMOTE_PORT"
remote = "$REMOTE_ADDR:$REMOTE_PORT"
protocol = "$PROTOCOL"

[security.tls]
enabled = $TLS_ENABLED
insecure = true
EOF

echo "✅ 配置文件生成成功：$CONFIG_FILE"

cat > $SERVICE_FILE <<EOF
[Unit]
Description=Realm Proxy Service
After=network.target

[Service]
Type=simple
ExecStart=$REALM_BIN -c $CONFIG_FILE
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# 自动开放防火墙端口
echo "🔓 正在开放防火墙端口 $REMOTE_PORT（TCP/UDP）..."
iptables -I INPUT -p tcp --dport $REMOTE_PORT -j ACCEPT
iptables -I INPUT -p udp --dport $REMOTE_PORT -j ACCEPT

if command -v netfilter-persistent &>/dev/null; then
    netfilter-persistent save
else
    echo "⚠️ 建议执行：apt install iptables-persistent -y"
fi

systemctl daemon-reload
systemctl enable realm
systemctl restart realm

echo "✅ Realm 服务已启动并设置开机自启"
systemctl status realm --no-pager
