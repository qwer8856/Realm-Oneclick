# Realm 一键安装脚本

## 使用说明

请在 Linux 服务器上运行此脚本安装 Realm。

### 参数说明（必须填写）

```
./install_realm.sh <protocol> <remote_addr> <remote_port> <tls_enabled>
```

- `protocol` ：协议名称（如 shadowsocks、vmess 等）
- `remote_addr` ：远程服务器 IP 或域名
- `remote_port` ：远程服务器端口
- `tls_enabled` ：是否启用 TLS，填写 `true` 或 `false`

### 示例

```bash
./install_realm.sh shadowsocks 103.180.28.134 16589 false
```

---

脚本会：

- 下载 Realm 二进制
- 生成配置文件 `/etc/realm/config.toml`
- 创建 systemd 服务 `realm.service` 并启动
- 设置开机自启

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
