- https://sinhvientot.net/huong-dan-cau-hinh-vlan-tren-switch-cisco/
- https://michael.mckinnon.id.au/2016/05/05/configuring-ubuntu-16-04-static-ip-address/
- https://forum.openwrt.org/t/routing-between-vlans/27797/8
- https://openwrt.org/docs/guide-user/base-system/basic-networking
- https://openwrt.org/docs/guide-user/network/wan/multiwan/multiwan_package
opkg install mwan3
- https://oldwiki.archive.openwrt.org/doc/uci/network
- https://openwrt.org/docs/guide-user/services/vpn/openvpn/dual-wan
- https://www.karlrupp.net/en/computer/nat_tutorial

```
root@OpenWrt:~# iptables -t nat -A POSTROUTING -o eth2.10 -j MASQUERADE
root@OpenWrt:~# iptables -t nat -A POSTROUTING -o eth2.20 -j MASQUERADE\
iptables -t nat -L -vn
root@OpenWrt:~# iptables -t nat -A POSTROUTING -o eth2.20 -s 10.0.10.0/24 -j MASQUERADE
root@OpenWrt:~# iptables -t nat -A POSTROUTING -o eth2.20 -s 10.0.20.0/24 -j MASQUERADE
root@OpenWrt:~# iptables -t nat -A POSTROUTING -o eth2.10 -s 10.0.20.0/24 -j MASQUERADE
root@OpenWrt:~# iptables -t nat -A POSTROUTING -o eth2.10 -s 10.0.10.0/24 -j MASQUERADE

```
