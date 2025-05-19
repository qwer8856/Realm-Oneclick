# Realm 一键安装脚本

支持协议：vmess / vless / trojan / shadowsocks / socks5 / http

## 使用说明

```bash
bash <(curl -Ls https://raw.githubusercontent.com/qwer8856/Realm-Oneclick/main/install.sh) [协议] [目标IP:端口] [本地监听端口] [TLS true/false]
```

### 示例

```bash
bash <(curl -Ls https://raw.githubusercontent.com/qwer8856/Realm-Oneclick/main/install.sh) vmess 1.2.3.4:10000 443 false
```

- 默认协议：vmess
- 默认监听端口：443
- 默认 TLS：false
