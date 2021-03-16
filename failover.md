- File /etc/rc.local
```
# Put your custom commands here that should be executed once
# the system init finished. By default this file does nothing.
route add default gw 203.0.0.2 dev eth2.10
route add default gw 203.0.2.2 dev eth2.30
route add default gw 203.0.1.2 dev eth2.20
exit 0
```

- echo "10" > /proc/sys/net/ipv4/route/gc_timeout 

