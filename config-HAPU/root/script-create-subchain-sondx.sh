#!/bin/bash

iptables -t mangle -N DNS
iptables -t mangle -A PREROUTING -p udp -m udp --dport 53 -j DNS