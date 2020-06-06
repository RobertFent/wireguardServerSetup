#!/bin/sh -e

/init.sh

#publickeyclient = $( cat /keys/publickeyclient )

#echo $publickeyclient
# wg set wg0 peer $publickkeyclient endpoint 46.83.86.42:51820 allowed-ips 

wg-quick up wg0

tail -f /dev/null
