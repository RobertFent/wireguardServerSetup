# wireguardServerSetup
Server-side setup for wireguard

## prerequisite
Firewall rules for vpn usage:
```
sudo iptables -A INPUT -p udp --dport 51820 -j ACCEPT   # enable port 51820/udp for wireguard
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT  # enable 22/tcp for ssh
```

## how to use
1. Build docker image
```
docker build -t robertfent1/wireguard-host -f ./DockerFile .
```
2. Run ```up``` in the folder where docker-compose.yml is
3. Copy client-wg0.conf.tar.gz from container (file needed for client setup)
```
docker cp <containerId>:/etc/wireguard/peers/client-wg0.conf.tar.gz client-wg0.conf.tar.gz
```

## how to test
1. Ip addresses
```
ip a show wg0
```
should print:
```
wg0: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1420 qdisc noqueue state UNKNOWN group default qlen 1000
link/none
inet 10.0.0.1/24 scope global wg0
   valid_lft forever preferred_lft forever
```

2. Ssh into client
```
ssh pi@10.0.0.2
```
3. Ping client
```
ping 10.0.0.2
```
should print something like this:
```
PING 10.0.0.2 (10.0.0.2) 56(84) bytes of data.
64 bytes from 10.0.0.2: icmp_seq=1 ttl=64 time=18.7 ms
64 bytes from 10.0.0.2: icmp_seq=2 ttl=64 time=19.1 ms
64 bytes from 10.0.0.2: icmp_seq=3 ttl=64 time=19.0 ms
64 bytes from 10.0.0.2: icmp_seq=4 ttl=64 time=19.0 ms
```
