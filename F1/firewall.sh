#firewall F1

iptables -F
iptables -t nat -F

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

iptables -N greendmz
iptables -N greenred
iptables -N greeninet
iptables -N dmzgreen
iptables -N dmzinet
iptables -N inetgreen
iptables -N inetdmz
iptables -N redgreen

iptables -A FORWARD -i eth1 -d 10.0.4.0/23 -j greendmz
iptables -A FORWARD -s 10.0.4.0/23 -o eth1 -j dmzgreen
iptables -A FORWARD -i eth1 -d 10.0.0.0/22 -j greenred
iptables -A FORWARD -s 10.0.0.0/22 -o eth1 -j redgreen
iptables -A FORWARD -i eth1 -o eth0 -j greeninet
iptables -A FORWARD -i eth0 -o eth1 -j inetgreen
iptables -A FORWARD -s 10.0.4.0/23 -o eth0 -j dmzinet
iptables -A FORWARD -i eth0 -d 10.0.4.0/23 -j inetdmz

iptables -A greendmz -p tcp -d 10.0.4.2 --dport 80 -j ACCEPT
iptables -A greendmz -p udp -d 10.0.5.2 --dport 53 -j ACCEPT
iptables -A dmzgreen -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A greenred -j ACCEPT
iptables -A redgreen -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A greeninet -j ACCEPT
iptables -A inetgreen -j ACCEPT
iptables -A inetdmz -j ACCEPT
iptables -A dmzinet -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -t nat -A PREROUTING -d 10.0.7.14 -p tcp --dport 80 -j DNAT --to-destination 10.0.4.2
iptables -t nat -A PREROUTING -d 10.0.7.14 -p udp --dport 53 -j DNAT --to-destination 10.0.5.2