#!/bin/bash

mkdir -p /data
mkdir -p /config

echo "waiting on eth1"
/pipework --wait -i eth1

if [ ! -f /config/dhcpd.conf ]; then
  if [ "$SUBNET" == '_' ];  then echo "SUBNET is not set"; exit 1; fi
  if [ "$NETMASK" == '_' ]; then echo "NETMASK is not set"; exit 1; fi
  if [ "$RANGE" == '_' ];   then echo "RANGE is not set"; exit 1; fi
  if [ "$MYIP" == '_' ];   then echo "MYIP is not set"; exit 1; fi
  if [ "$GATEWAY" == '_' ];   then echo "GATEWAY is not set"; exit 1; fi

  cp /dhcpd.conf.template /config/dhcpd.conf

  sed -i "s/_SUBNET_/$SUBNET/g" /config/dhcpd.conf
  sed -i "s/_NETMASK_/$NETMASK/g" /config/dhcpd.conf
  sed -i "s/_RANGE_/$RANGE/g" /config/dhcpd.conf
  sed -i "s/_MYIP_/$MYIP/g" /config/dhcpd.conf
  sed -i "s/_GATEWAY_/$GATEWAY/g" /config/dhcpd.conf
  sed -i "s/_DNS1_/$DNS1/g" /config/dhpcd.conf
  sed -i "s/_DNS2_/$DNS2/g" /config/dhcpd.conf
  sed -i "s/_DEFAULT-LEASE-TIME_/$DEFAULT_LEASE_TIME/g" /config/dhcpd.conf
  sed -i "s/_MAX-LEASE-TIME_/$MAX_LEASE_TIME/g" /config/dhcpd.conf
fi

if [ ! -f /data/dhcpd.leases ]; then
    touch /data/dhcpd.leases
fi

exec /usr/sbin/dhcpd $@
