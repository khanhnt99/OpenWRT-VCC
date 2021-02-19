# Libraries
. /lib/functions.sh #  load UCI configuration files

# Variables
ACTION="${1:-start}"
TC=/usr/sbin/tc

# Functions
run_traffic_control(){
        local section="$1"

        IFACE=$(config_get "$section" interface) 

        IF=$(uci -q get network.${IFACE}.ifname) # lay ra interface vat li
        if [ $? -eq 1 ]; then
                        #echo "No network config for ${IFACE}"
                        return
        fi


        GWIPADDR=$(uci -q get network.${IFACE}.ipaddr)
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

        U32="$TC filter replace dev $IF protocol ip parent 1:0 prio 1 u32"

        # Use tc tool
        $TC qdisc add dev $IF root handle 1: htb default 999 > /dev/null 2>&1
        $TC qdisc add dev $IF handle ffff: ingress > /dev/null 2>&1
        $TC qdisc add dev ifb$VLAN root handle 1: htb default 10

        for IP in $(seq $START $END)
        do
                IPADDR="$BASEIP.$IP"

                # Limit bandwidth Download
                $TC class replace dev $IF parent 1: classid 1:$IP htb rate ${DOWNLOAD}kbit > /dev/null 2>&1
                $U32 match ip dst $IPADDR/32 flowid 1:$IP > /dev/null 2>&1

                # Limit bandwidth Upload
                $TC filter add dev $IF parent ffff: protocol ip u32 match ip src $IPADDR/32 \
                    action mirred egress redirect dev ifb$VLAN > /dev/null 2>&1
                $TC class replace dev ifb$VLAN parent 1:1 classid 1:$IP htb rate ${UPLOAD}kbit > /dev/null 2>&1
                $TC filter replace dev ifb$VLAN parent 1:0 protocol ip u32 match ip src $IPADDR/32 flowid 1:$IP > /dev/null 2>&1
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
config_load throttle #load tu file /etc/config/throttle
# restart start stop traffic shaping
case "$1" in

  start)
    LIGHTGREEN='\033[1;32m'
    NC='\033[0m'
    echo -n -e "${LIGHTGREEN}Starting bandwidth shaping: \n${NC}"
    config_foreach run_traffic_control:q # chay ham run_traffic_control
    echo "done"
    ;;

  stop)
    LIGHTGREEN='\033[1;32m'
    NC='\033[0m'
    echo -n -e "${LIGHTGREEN}Stopping bandwidth shaping: \n${NC}"
    config_foreach stop_traffic_control # chay ham stop_traffic_control
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