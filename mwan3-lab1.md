![](https://i.ibb.co/2jJFJ9H/Screenshot-from-2021-02-03-16-07-11.png)

## network file
```
config interface 'loopback'
	option ifname 'lo'
	option proto 'static'
	option ipaddr '127.0.0.1'
	option netmask '255.0.0.0'

config globals 'globals'
	option ula_prefix 'fd64:b883:88c2::/48'

config interface 'lan'
	option type 'bridge'
	option ifname 'eth0'
	option proto 'static'
	option ipaddr '192.168.1.1'
	option netmask '255.255.255.0'

# Connect internet
#config interface 'wan0'
#	option ifname 'eth4'
#	option proto 'dhcp'
	

# console interface
config interface 'lan1'
	option ifname 'eth1'
	option proto 'static'
	option ipaddr '192.168.0.1'
	option netmask '255.255.255.0'
	option dns '8.8.8.8'

config interface 'wan1'
	option ifname 'eth2'
	option proto 'static'
        option ipaddr '203.0.0.1'
        option netmask '255.255.255.0'
	option gateway '203.0.0.2'
	option metric '10'
	option dns '8.8.8.8'

config interface 'wan2'
	option ifname 'eth3' 
        option proto 'static'        
        option ipaddr '203.0.1.1'
	option netmask '255.255.255.0'  
	option gateway '203.0.1.2'
	option metric '20'
	option dns '8.8.8.8'

```

## firewall file

```
config defaults
	option syn_flood	1
	option input		ACCEPT
	option output		ACCEPT
	option forward		REJECT
# Uncomment this line to disable ipv6 rules
#	option disable_ipv6	1

config zone
	option name		lan
	list   network		'lan'
	option input		ACCEPT
	option output		ACCEPT
	option forward		ACCEPT

config zone
	option name	lan1
	list network	'lan1'
	option input 	ACCEPT
	option output	ACCEPT
	option forward 	ACCEPT

config zone
	option name		wan1
	list network		'wan1'
	option input		ACCEPT
	option output		ACCEPT
	option forward		ACCEPT
	option masq		1
	option mtu_fix 		1

config zone
	option name		wan2
	list network		'wan2'
	option input		ACCEPT
	option output		ACCEPT
	option forward		ACCEPT
	option masq		1
	option mtu_fix		1

config forwarding
	option src		lan
	option dest		wan

config forwarding 
	option src 		lan1
	option dest 		wan1

config forwarding 
	option src 		lan1
	option dest		wan2
# We need to accept udp packets on port 68,
# see https://dev.openwrt.org/ticket/4108
config rule
	option name		Allow-DHCP-Renew
	option src		wan
	option proto		udp
	option dest_port	68
	option target		ACCEPT
	option family		ipv4

# Allow IPv4 ping
config rule
	option name		Allow-Ping
	option src		wan
	option proto		icmp
	option icmp_type	echo-request
	option family		ipv4
	option target		ACCEPT

config rule
	option name		Allow-IGMP
	option src		wan
	option proto		igmp
	option family		ipv4
	option target		ACCEPT

# Allow DHCPv6 replies
# see https://dev.openwrt.org/ticket/10381
config rule
	option name		Allow-DHCPv6
	option src		wan
	option proto		udp
	option src_ip		fc00::/6
	option dest_ip		fc00::/6
	option dest_port	546
	option family		ipv6
	option target		ACCEPT

config rule
	option name		Allow-MLD
	option src		wan
	option proto		icmp
	option src_ip		fe80::/10
	list icmp_type		'130/0'
	list icmp_type		'131/0'
	list icmp_type		'132/0'
	list icmp_type		'143/0'
	option family		ipv6
	option target		ACCEPT

# Allow essential incoming IPv6 ICMP traffic
config rule
	option name		Allow-ICMPv6-Input
	option src		wan
	option proto		icmp
	list icmp_type		echo-request
	list icmp_type		echo-reply
	list icmp_type		destination-unreachable
	list icmp_type		packet-too-big
	list icmp_type		time-exceeded
	list icmp_type		bad-header
	list icmp_type		unknown-header-type
	list icmp_type		router-solicitation
	list icmp_type		neighbour-solicitation
	list icmp_type		router-advertisement
	list icmp_type		neighbour-advertisement
	option limit		1000/sec
	option family		ipv6
	option target		ACCEPT

# Allow essential forwarded IPv6 ICMP traffic
config rule
	option name		Allow-ICMPv6-Forward
	option src		wan
	option dest		*
	option proto		icmp
	list icmp_type		echo-request
	list icmp_type		echo-reply
	list icmp_type		destination-unreachable
	list icmp_type		packet-too-big
	list icmp_type		time-exceeded
	list icmp_type		bad-header
	list icmp_type		unknown-header-type
	option limit		1000/sec
	option family		ipv6
	option target		ACCEPT

config rule
	option name		Allow-IPSec-ESP
	option src		wan
	option dest		lan
	option proto		esp
	option target		ACCEPT

config rule
	option name		Allow-ISAKMP
	option src		wan
	option dest		lan
	option dest_port	500
	option proto		udp
	option target		ACCEPT

# include a file with users custom iptables rules
config include
	option path /etc/firewall.user


### EXAMPLE CONFIG SECTIONS
# do not allow a specific ip to access wan
#config rule
#	option src		lan
#	option src_ip	192.168.45.2
#	option dest		wan
#	option proto	tcp
#	option target	REJECT

# block a specific mac on wan
#config rule
#	option dest		wan
#	option src_mac	00:11:22:33:44:66
#	option target	REJECT

# block incoming ICMP traffic on a zone
#config rule
#	option src		lan
#	option proto	ICMP
#	option target	DROP

# port redirect port coming in on wan to lan
#config redirect
#	option src			wan
#	option src_dport	80
#	option dest			lan
#	option dest_ip		192.168.16.235
#	option dest_port	80
#	option proto		tcp

# port redirect of remapped ssh port (22001) on wan
#config redirect
#	option src		wan
#	option src_dport	22001
#	option dest		lan
#	option dest_port	22
#	option proto		tcp

### FULL CONFIG SECTIONS
#config rule
#	option src		lan
#	option src_ip	192.168.45.2
#	option src_mac	00:11:22:33:44:55
#	option src_port	80
#	option dest		wan
#	option dest_ip	194.25.2.129
#	option dest_port	120
#	option proto	tcp
#	option target	REJECT

#config redirect
#	option src		lan
#	option src_ip	192.168.45.2
#	option src_mac	00:11:22:33:44:55
#	option src_port		1024
#	option src_dport	80
#	option dest_ip	194.25.2.129
#	option dest_port	120
#	option proto	tcp

```

## mwan3 file

```
config globals 'globals'
	option mmx_mask '0x3F00'
	option local_source 'lan'


config interface 'wan1'
	option enabled '1'
	list track_ip '8.8.4.4'
	list track_ip '8.8.8.8'
	list track_ip '208.67.222.222'
	list track_ip '208.67.220.220'
	option family 'ipv4'
	option reliability '2'
	option count '1'
	option timeout '2'
	option interval '5'
	option down '3'
	option up '8'

config interface 'wan2'
	option enabled '1'
	list track_ip '8.8.4.4'
	list track_ip '8.8.8.8'
	list track_ip '208.67.222.222'
	list track_ip '208.67.220.220'
	option family 'ipv4'
	option reliability '2'
	option count '1'
	option timeout '2'
	option interval '5'
	option down '3'
	option up '8'


config member 'wan1_m1_w3'
	option interface 'wan1'
	option metric '1'
	option weight '3'

config member 'wan2_m1_w3'
	option interface 'wan2'
	option metric '1'
	option weight '3'

config policy 'wan1_only'
	list use_member 'wan1_m1_w3'

config policy 'wan2_only'
	list use_member 'wan2_m1_w3'

config policy 'balanced'
	list use_member 'wan1_m1_w3'
	list use_member 'wan2_m1_w3'
	option last_resort 'unreachable'

config rule 'default_rule'
	option dest_ip '0.0.0.0/0'
	option use_policy 'balanced'
```

## iptables
```
iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -d 203.0.0.0/24 -o eth2 -j MASQUERADE
```

