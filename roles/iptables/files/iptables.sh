#!/bin/bash
set -xe

cp=$(which cp)
now=$(date +"%Y%m%d%H%M%S")
iptables-save > /etc/sysconfig/iptables
$cp /etc/sysconfig/iptables "/etc/sysconfig/iptables.bak${now}"

iptables -F
iptables -X
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables-save > /etc/sysconfig/iptables
