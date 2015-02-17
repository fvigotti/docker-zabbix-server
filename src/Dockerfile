FROM ubuntu:14.04


ENV DEBIAN_FRONTEND noninteractive

# base packages
RUN apt-get update && \
    apt-get -y --quiet upgrade && \
    apt-get -y clean && \
    apt-get -y -q install  libcurl3 libiksemel3 libmysqlclient18 libodbc1 unixodbc libopenipmi0 libsnmp30 libssh2-1 libxml2  wget fping  mysql-common ucf procps iproute





ADD ./zabbix-server/zabbix-server-mysql_2.4.3-1+trusty_amd64.deb /root/zabbix-server-mysql_2.4.3-1+trusty_amd64.deb
RUN dpkg -i /root/zabbix-server-mysql_2.4.3-1+trusty_amd64.deb

# Zabbix Conf Files
ADD ./zabbix-server/zabbix_server.conf	/etc/zabbix/zabbix_server.conf
RUN chmod 640 /etc/zabbix/zabbix_server.conf && \
    chown root:zabbix /etc/zabbix/zabbix_server.conf && \
    mkdir /var/run/zabbix/ && chown zabbix /var/run/zabbix/ && \
    mkdir /var/log/zabbix/ && chown zabbix /var/log/zabbix/

# Expose the Zabbix Server port 10051
EXPOSE 10051

# Start the custom zabbix_server binary in foreground mode ( -f )
CMD ["/usr/sbin/zabbix_server", "-f", " -c", "/etc/zabbix/zabbix_server.conf"]

