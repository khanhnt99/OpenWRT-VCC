#!/bin/sh

. /lib/functions.sh
IPS="/usr/sbin/ipset -!"
IPS_SETNAME="blocked_domain_set"
BLOCKED_IPS="/tmp/blocked_domain_ip"

DNS_FILE="/etc/config/blockdns"
MANGLE_RULES=""

create_rule(){
	if [ ! -z "$1" ]; then
		rule_line=$(/root/ipt_rule $1)

		MANGLE_RULES=$(iptables -t mangle -S)
	
		if echo "$MANGLE_RULES" | grep -q "$1" ; then 
			:
		else
			eval $rule_line
		fi
	fi
}

main() {

#> /etc/firewall.user

> $BLOCKED_IPS

cat $DNS_FILE | while read domain
	do
		echo "$domain"
		IPADDR=$(dig +short $domain @8.8.8.8 | tail -n1)
		#echo $IPADDR
			
		if [ ! -z "$IPADDR" ]; then
			echo $IPADDR >> $BLOCKED_IPS
			
		fi
		
		#create_rule $domain

	done

sed -i -e '/0\.0\.0\.0/d' -e '/1\.1\.1\.1/d' -e '/127\.0\.0\.1/d' \
       -e '/8\.8\.8\.8/d' -e '/8\.8\.4\.4/d' -e '/208\.67\.222\.220/d' \
       -e '/208\.67\.222\.222/d' -e '/151\.139\.128\.10/d' $BLOCKED_IPS


$IPS create $IPS_SETNAME hash:net family inet hashsize 1024 maxelem 65536
$IPS flush $IPS_SETNAME


cat $BLOCKED_IPS | while read IPADDR
	do
		$IPS add $IPS_SETNAME $IPADDR 
	
	done

}

main "$@"
