#!/bin/bash
#Author Son Do Xuan

firewall_config_file="/etc/config/firewall"

# ping -w 10 -c 3 10.0.1.4
dig google.com @10.0.1.4
if [ $? != 0 ]
then
    iptables -t mangle -L PREROUTING -n | grep "192.168.0.0/16"
    if [ $? == 0 ]
    then
        iptables -t mangle -D PREROUTING -s 192.168.0.0/16 -p udp -m udp --dport 53 -j ACCEPT
    fi

    grep "option dest_ip '10.0.1.4'" $firewall_config_file
    if [ $? == 0 ]
    then
        sed -i "s/option dest_ip '10.0.1.4'/option dest_ip '8.8.8.8'/" $firewall_config_file
        /etc/init.d/firewall reload
    fi
else
    iptables -t mangle -L PREROUTING -n | grep "192.168.0.0/16"
    if [ $? != 0 ]
    then
        iptables -t mangle -I PREROUTING 1 -s 192.168.0.0/16 -p udp -m udp --dport 53 -j ACCEPT
    fi

    grep "option dest_ip '8.8.8.8'" $firewall_config_file
    if [ $? == 0 ]
    then
        sed -i "s/option dest_ip '8.8.8.8'/option dest_ip '10.0.1.4'/" $firewall_config_file
        /etc/init.d/firewall reload
    fi
fi

