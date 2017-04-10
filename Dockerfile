FROM alpine:3.5

RUN apk add --no-cache bash dhcp net-tools supervisor rsyslog logrotate

ADD dhcpd/dhcpd.sh dhcpd/dhcpd.conf.template /usr/share/dhcpd/
ADD dhcpd/dhcpd-reservations.conf /etc/dhcpd-reservations.conf
ADD supervisor/supervisord.conf /etc/supervisord.conf
ADD rsyslogd/rsyslog.conf /etc/rsyslog.conf
ADD supervisor/conf.d /usr/share/supervisor/conf.d/
ADD logrotate/logrotate.conf /etc/logrotate.conf
ADD logrotate/dhcpd /etc/logrotate.d/dhcpd

ENV SUBNET= NETMASK= RANGE_PXE= RANGE_STATIC= RANGE_OTHER= GATEWAY= SERVER_IP= NAMESERVERS= \
    DEFAULT_LEASE_TIME=600 \
    MAX_LEASE_TIME=1800

EXPOSE 67 67/udp 547 547/udp 647 647/udp 847 847/udp

ENTRYPOINT ["supervisord"]

CMD ["-c", "/etc/supervisord.conf", "-n"]
