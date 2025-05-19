# Realm 一键安装脚本（自动开放端口版）

## 使用方式

```bash
./install_realm.sh <protocol> <remote_addr> <remote_port> <tls_enabled>
```

### 参数说明

- `protocol`：协议名称（shadowsocks、vmess、vless、trojan 等）
- `remote_addr`：远程服务器 IP 或域名
- `remote_port`：远程端口号
- `tls_enabled`：true / false（是否启用 TLS）

### 示例

```bash
./install_realm.sh shadowsocks 103.180.28.134 16589 false
```

---

## 特性

- 自动下载最新 Realm
- 自动生成配置文件 `/etc/realm/config.toml`
- 自动创建并启动 systemd 服务
- ✅ 自动开放监听端口（使用 iptables）

---

## 卸载 Realm

```bash
systemctl stop realm
systemctl disable realm
rm -rf /etc/realm
rm -f /usr/local/bin/realm
rm -f /etc/systemd/system/realm.service
systemctl daemon-reload
```
