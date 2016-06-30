FROM alpine


RUN apk add --no-cache bash dhcp 

ADD https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework /pipework
ADD dhcpd.sh /dhcpd.sh
ADD dhcpd.conf.template /dhcpd.conf.template

RUN chmod +x /dhcpd.sh /pipework

ENV SUBNET= NETMASK= RANGE= GATEWAY= MYIP= \
    NAMESERVERS=10.19.55.1 \
    DEFAULT_LEASE_TIME=600 \
    MAX_LEASE_TIME=1800


EXPOSE 67 67/udp 547 547/udp 647 647/udp 847 847/udp

ENTRYPOINT ["/dhcpd.sh"]
CMD ["-f", "-cf", "/config/dhcpd.conf", "-lf", "/data/dhcpd.leases", "--no-pid"]
