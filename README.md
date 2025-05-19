# Realm 一键安装脚本

支持多协议（vmess / vless / trojan / shadowsocks / socks5 / http）代理中转部署。

## 使用方式

```bash
bash <(curl -Ls https://raw.githubusercontent.com/your-username/realm-installer/main/install.sh) [协议] [目标地址:端口] [本地监听端口] [TLS: true/false]
```

## 示例

```bash
# 中转 vmess，监听 443，目标为 1.2.3.4:10000，无 TLS
bash <(curl -Ls https://raw.githubusercontent.com/your-username/realm-installer/main/install.sh) vmess 1.2.3.4:10000 443 false
```

- 协议支持：vmess / vless / trojan / shadowsocks / socks5 / http
- 默认协议：vmess
- 默认监听端口：443
- 默认 TLS：false
