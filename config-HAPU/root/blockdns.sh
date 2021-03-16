#!/bin/sh

. /lib/functions.sh

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


cat $DNS_FILE | while read domain
	do
		echo "$domain"
		
		create_rule $domain

	done



}

main "$@"
