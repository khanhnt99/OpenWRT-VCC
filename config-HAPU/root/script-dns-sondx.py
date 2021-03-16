#!/usr/bin/python

import argparse


def dec_to_hex(dec_num):
    hex_number = hex(dec_num).strip('0x')
    if len(hex_number) == 1:
        hex_number = '0' + hex_number
    else:
        hex_number = hex_number
    return hex_number


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Script to convert domain to iptable block rule')
    parser.add_argument("domain", help="domain to block")
    argument = parser.parse_args()
    domain = argument.domain
    domain_split = domain.split('.')
    hex_domain = ''
    for i in domain_split:
        hex_i = dec_to_hex(len(i))
        hex_domain = hex_domain + '|%s|%s' % (hex_i, i)
    block_rule = 'iptables -w -t mangle -D DNS -m string --hex-string \"%s\" --algo bm --from 40 -m comment --comment \"Custom rule Block %s\" -j DROP' % (hex_domain, domain)

    print block_rule
