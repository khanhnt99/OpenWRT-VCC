config interface 'loopback'
        option ifname 'lo'
        option proto 'static'
        option ipaddr '127.0.0.1'
        option netmask '255.0.0.0'

config interface 'lan'
        option type 'bridge'
        option ifname 'eth0'
        option proto 'static'
        option ipaddr '192.168.1.1'
        option netmask '255.255.255.0'

config interface 'wan1'
        option ifname 'eth2'
        option proto 'static'
        option ipaddr '203.0.0.1'
        option netmask '255.255.255.0'
        option gateway '203.0.0.2'
        list dhcp_option '8.8.8.8,8.8.4.4'

#config interface 'wan2'
config switch
        option name 'switch0'
        option reset '1'
        option enable_vlan '1'

config switch_vlan
        option device 'switch0'
        option vlan '10'
        option vid '10'
        #option ports '2 3t 5t'

config switch_vlan
        option device 'switch0'
        option vlan '20'
        option ports '4 6t'
        option vid '20'

config interface 'vlan10'
        #option type 'bridge'
        option ifname 'eth1.10'
        option proto 'static'
        option ipaddr '10.0.10.1'
        option netmask '255.255.255.0'

config interface 'vlan20'
        #option type 'bridge'
        option ifname 'eth1.20'
        option proto 'static'
        option ipaddr '10.0.20.1'
        option netmask '255.255.255.0'

