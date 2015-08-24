#!/bin/bash

mkdir -p /data

echo "waiting on eth1"
/pipework --wait -i eth1

if [ ! -f /data/dhcpd.conf ]; then
  if [ "$SUBNET" == '_' ];  then echo "SUBNET is not set"; exit 1; fi
  if [ "$NETMASK" == '_' ]; then echo "NETMASK is not set"; exit 1; fi
  if [ "$RANGE" == '_' ];   then echo "RANGE is not set"; exit 1; fi
  if [ "$MYIP" == '_' ];   then echo "MYIP is not set"; exit 1; fi
  if [ "$GATEWAY" == '_' ];   then echo "GATEWAY is not set"; exit 1; fi

  cp /dhcpd.conf.template /data/dhcpd.conf

  sed -i "s/_SUBNET_/$SUBNET/g" /data/dhcpd.conf
  sed -i "s/_NETMASK_/$NETMASK/g" /data/dhcpd.conf
  sed -i "s/_RANGE_/$RANGE/g" /data/dhcpd.conf
  sed -i "s/_MYIP_/$MYIP/g" /data/dhcpd.conf
  sed -i "s/_GATEWAY_/$GATEWAY/g" /data/dhcpd.conf
fi

if [ ! -f /data/dhcpd.leases ]; then
    touch /data/dhcpd.leases
fi

exec /usr/sbin/dhcpd $@
