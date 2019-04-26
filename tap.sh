#!/bin/sh

# Crea interfaccia di rete tap0
tunctl -g netdev -t tap0
ifconfig tap0 10.0.7.13
ifconfig tap0 netmask 255.255.255.252
ifconfig tap0 broadcast 10.0.7.15
ifconfig tap0 up

# Crea regole di firewalling (cambiare wlp6s0 con il nome della propria scheda di rete)
iptables -t nat -A POSTROUTING -o wlp2s0 -j MASQUERADE
iptables -A FORWARD -i tap0 -j ACCEPT

# Abilita il forwarding su host locale 
sysctl -w net.ipv4.ip_forward=1

# Aggiunge le rotte alle varie subnets
route add -net 10.0.7.12/30 gw 10.0.7.14 dev tap0
route add -net 10.0.6.0/24 gw 10.0.7.14 dev tap0
route add -net 10.0.7.8/30 gw 10.0.7.14 dev tap0
route add -net 10.0.4.0/23 gw 10.0.7.14 dev tap0
route add -net 10.0.7.4/30 gw 10.0.7.14 dev tap0
route add -net 10.0.7.0/30 gw 10.0.7.14 dev tap0
route add -net 10.0.0.0/22 gw 10.0.7.14 dev tap0
