#!/bin/sh

. /lib/functions.sh

IPS="/usr/sbin/ipset"


add_ipset()
{
	$IPS add $2 $1
	#echo "$2 $1"
}

ipsets()
{
	config_load ipset
	ips_setname="ipset_$1"
		
	$IPS create $ips_setname hash:net family inet hashsize 1024 maxelem 65536
	$IPS flush $ips_setname
	
	config_list_foreach $1 addresses add_ipset $ips_setname
		
}

start()
{
	config_load ipset
	
	config_foreach ipsets ipset
}

stop()
{
	for ipset in $($IPS -n list | grep ipset_); do
		$IPS -q destroy $ipset
	done

}

restart() {
	stop
	start
}

case "$1" in
	start|stop|restart|reload)
		$*
	;;
	*)
		help
	;;
esac

exit 0
