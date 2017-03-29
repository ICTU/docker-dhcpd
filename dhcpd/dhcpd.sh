#!/bin/bash

if [ ! -f /etc/dhcpd.conf ]; then
  if [ "$SUBNET" == '_' ];  then echo "SUBNET is not set"; exit 1; fi
  if [ "$NETMASK" == '_' ]; then echo "NETMASK is not set"; exit 1; fi
  if [ "$RANGE_PXE" == '_' ];   then echo "RANGE_PXE is not set"; exit 1; fi
  if [ "$RANGE_STATIC" == '_' ];   then echo "RANGE_STATIC is not set"; exit 1; fi
  if [ "$RANGE_OTHER" == '_' ];   then echo "RANGE_OTHER is not set"; exit 1; fi
  if [ "$SERVER_IP" == '_' ];   then echo "SERVER_IP is not set"; exit 1; fi
  if [ "$GATEWAY" == '_' ];   then echo "GATEWAY is not set"; exit 1; fi

  cp /usr/share/dhcpd/dhcpd.conf.template /etc/dhcpd.conf

  sed -i "s/_SUBNET_/$SUBNET/g" /etc/dhcpd.conf
  sed -i "s/_NETMASK_/$NETMASK/g" /etc/dhcpd.conf
  sed -i "s/_RANGE_PXE_/$RANGE_PXE/g" /etc/dhcpd.conf
  sed -i "s/_RANGE_STATIC_/$RANGE_STATIC/g" /etc/dhcpd.conf
  sed -i "s/_RANGE_OTHER_/$RANGE_OTHER/g" /etc/dhcpd.conf
  sed -i "s/_SERVER_IP_/$SERVER_IP/g" /etc/dhcpd.conf
  sed -i "s/_GATEWAY_/$GATEWAY/g" /etc/dhcpd.conf
  sed -i "s/_NAMESERVERS_/$NAMESERVERS/g" /etc/dhcpd.conf
  sed -i "s/_DEFAULT_LEASE_TIME_/$DEFAULT_LEASE_TIME/g" /etc/dhcpd.conf
  sed -i "s/_MAX_LEASE_TIME_/$MAX_LEASE_TIME/g" /etc/dhcpd.conf
fi

if [ ! -f /data/dhcpd.leases ]; then
    touch /data/dhcpd.leases
fi

exec /usr/sbin/dhcpd $@
