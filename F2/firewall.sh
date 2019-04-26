#firewall F2

iptables -F
iptables -t nat -F

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

iptables -N reddmz
iptables -N redgreen
iptables -N redinet
iptables -N dmzred
iptables -N greenred
iptables -N inetred

iptables -A FORWARD -i eth1 -d 10.0.4.0/23 -j reddmz
iptables -A FORWARD -i eth1 -d 10.0.6.0/24 -j redgreen
iptables -A FORWARD -i eth1 -d 10.0.7.8/30 -j redinet
iptables -A FORWARD -s 10.0.4.0/23 -o eth1 -j dmzred
iptables -A FORWARD -s 10.0.6.0/24 -o eth1 -j greenred
iptables -A FORWARD -s 10.0.7.8/30 -o eth1 -j inetred

iptables -A reddmz -p tcp -d 10.0.4.2 --dport 80 -j ACCEPT
iptables -A reddmz -p udp -d 10.0.5.2 --dport 53 -j ACCEPT
iptables -A reddmz -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A redgreen -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A redinet -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A dmzred -j ACCEPT
iptables -A greenred -j ACCEPT
iptables -A inetred -j ACCEPT
