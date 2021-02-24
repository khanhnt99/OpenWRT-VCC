# Libraries
. /lib/functions.sh #  load UCI configuration files

# Variables
#ACTION="${1:-start}"
TC=/usr/sbin/tc

# Functions
run_traffic_control(){
        local section="$1"

        IFACE=$(config_get "$section" interface) # Lay ra gia tri dau tien sau interface

        IF=$(uci -q get network.${IFACE}.ifname) # Lay ra interface vat li
        if [ $? -eq 1 ]; then
                        #echo "No network config for ${IFACE}"
                        return
        fi


        GWIPADDR=$(uci -q get network.${IFACE}.ipaddr) # Lay ra dia chi IP cua interface vat li ${IFACE}
        if [ $? -eq 1 ]; then
                        #echo "No network config for ${IFACE}"
                        return
        fi


        ENABLED=$(config_get "$section" enabled)
        DOWNLOAD=$(config_get "$section" download)
        UPLOAD=$(config_get "$section" upload)
        START=$(config_get "$section" start)
        END=$(config_get "$section" end)

        BASEIP=`echo $GWIPADDR | cut -d"." -f1-3`
        VLAN=`echo $GWIPADDR | cut -d"." -f3`
        ip l add ifb$VLAN type ifb
        ip l set ifb$VLAN up

        echo $BASEIP.[$START-$END]


        # Use tc tool
	$TC qdisc add dev $IF handle ffff: ingress > /dev/null 2>&1
	$TC qdisc add dev ifb$VLAN root handle 1: htb default 10 > /dev/null 2>&1
	$TC qdisc add dev $IF root handle 1: htb default 10 > /dev/null 2>&1 
	
	#redirect ingress from physical interface to virtual interface
  #one for outgoing packets (egress path),
  #one for incoming packets (ingress path).
	$TC filter add dev $IF parent ffff: protocol ip u32 match u32 0 0 action mirred egress redirect dev ifb$VLAN > /dev/null 2>&1

	for i in $(seq $START $END); do
		IPADDR=$BASEIP.$i

		#Download limit
		$TC class add dev $IF parent 1:1 classid 1:$i htb rate ${DOWNLOAD}kbit >/dev/null 2>&1 #Add Bandwitch vao Interface 
		$TC filter add dev $IF protocol ip parent 1: prio 1 u32 match ip dst $IPADDR/32 flowid 1:$i > /dev/null 2>&1 #Match vao dia chi tuong ung 

		#Upload limit
		$TC class add dev ifb$VLAN parent 1:1 classid 1:$i htb rate ${UPLOAD}kbit >/dev/null 2>&1
		$TC filter add dev ifb$VLAN protocol ip parent 1: prio 1 u32 match ip src $IPADDR/32 flowid 1:$i > /dev/null 2>&1
	done
	
}

stop_traffic_control(){
        local section="$1"

        IFACE=$(config_get "$section" interface)

        IF=$(uci -q get network.${IFACE}.ifname)
        if [ $? -eq 1 ]; then
                        #echo "No network config for ${IFACE}"
                        return
        fi

        GWIPADDR=$(uci -q get network.${IFACE}.ipaddr)
        if [ $? -eq 1 ]; then
                        #echo "No network config for ${IFACE}"
                        return
        fi

        VLAN=`echo $GWIPADDR | cut -d"." -f3`

        # Use tc tool
        $TC qdisc del dev $IF root > /dev/null 2>&1

        $TC qdisc del dev $IF parent ffff: > /dev/null 2>&1
        $TC qdisc del dev ifb$VLAN root > /dev/null 2>&1
        ip l del ifb$VLAN
}


# Program
config_load throttle

case "$1" in

  start)
    LIGHTGREEN='\033[1;32m'
    NC='\033[0m'
    echo -n -e "${LIGHTGREEN}Starting bandwidth shaping: \n${NC}"
    config_foreach run_traffic_control
    echo "done"
    ;;

  stop)
    LIGHTGREEN='\033[1;32m'
    NC='\033[0m'
    echo -n -e "${LIGHTGREEN}Stopping bandwidth shaping: \n${NC}"
    config_foreach stop_traffic_control
    echo "done"
    ;;

  restart)
    LIGHTGREEN='\033[1;32m'
    NC='\033[0m'
    echo -n -e "${LIGHTGREEN}Restarting bandwidth shaping: \n${NC}"
    echo -n -e "${LIGHTGREEN}STOP: \n${NC}"
    config_foreach stop_traffic_control
    sleep 1
    echo -n -e "${LIGHTGREEN}START: \n${NC}"
    config_foreach run_traffic_control
    echo "done"
    ;;


  *)
    pwd=$(pwd)
    echo "Usage: throttle {start|stop|restart}"
    ;;

esac

exit 0
