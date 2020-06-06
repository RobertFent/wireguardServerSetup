#!/bin/sh -e

echo 'Running init.sh...'

#
# generate private and public key
#

mkdir keys
cd keys

echo 'Generating Keys...'
umask 077

# server keys
wg genkey | tee privatekey | wg pubkey > publickey

# client keys
wg genkey | tee privatekeyclient | wg pubkey > publickeyclient

echo 'Keys generated!'

#
# create wg0 configs
#

echo 'Creating configs...'

pkserver=$( cat privatekey )
publickeyserver=$( cat publickey )

pkclient=$( cat privatekeyclient )
publickeyclient=$( cat publickeyclient )
#
# create wg0.conf for host
#

cat > /etc/wireguard/wg0.conf <<_EOF_
[Interface]
PrivateKey = $pkserver
Address = ${ADDRESS_SERVER}/24
ListenPort = 51820
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ens3 -j MASQUERADE
SaveConfig = true

[Peer]
PublicKey = $publickeyclient
AllowedIPs = ${ADDRESS_CLIENT}/32
_EOF_

#
# create wg0.conf for client
#

mkdir /etc/wireguard/peers
cd /etc/wireguard/peers

cat > /etc/wireguard/peers/client-wg0.conf <<_EOF_
[Interface]
PrivateKey = $pkclient
Address = ${ADDRESS_CLIENT}/24

[Peer]
PublicKey = $publickeyserver
Endpoint = ${SERVER_IP}:51820
AllowedIPs = ${ADDRESS_CLIENT}/24
PersistentKeepalive = 15
_EOF_

tar czf client-wg0.conf.tar.gz client-wg0.conf
rm client-wg0.conf

echo 'Configs created!'

#
# append peer to host config
#

# wg set wg0 peer $publickeyclient allowed-ips ${ADDRESS_CLIENT}

echo 'Init done!'
