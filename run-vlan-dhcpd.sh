#!/bin/bash

if [ "$(whoami)" != "root" ]; then
  echo "This script needs root privileges to run, use sudo"
  exit 2
fi

me=`basename $0`
function usage(){
  echo "Usage: $me vlanid network-interface"
  echo "Example: $me 55"
  exit 1
}
if [ $# -lt 2 ]; then
  usage
fi

vlanid=$1
netif=$2
octet3=$(($vlanid - 3000))

docker kill dhcp-$vlanid; docker rm dhcp-$vlanid;
docker run -d -e "MYIP=10.25.$octet3.1" -e "GATEWAY=10.25.$octet3.254" -e "SUBNET=10.25.$octet3.0" -e "NETMASK=255.255.255.0" -e "RANGE=10.25.$octet3.10 10.25.$octet3.250" --name dhcp-$vlanid docker-registry.isd.ictu:5000/docker-dhcpd

if [ -f "/opt/bin/pipework" ]; then
  pipework="/opt/bin/pipework"
elif [ -f "./pipework" ]; then
  pipework="./pipework"
else
  wget -O ./pipework https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework
  chmod +x ./pipework
  pipework="./pipework"
fi

echo "script is $pipework"

"$pipework" "$netif" dhcp-$vlanid 10.25.$octet3.1/24@10.25.$octet3.254 @"$vlanid"
