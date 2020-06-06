#!/bin/sh -e

/init.sh

wg-quick up wg0

# to make container run infinit
tail -f /dev/null
