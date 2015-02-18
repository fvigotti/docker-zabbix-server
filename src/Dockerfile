FROM ubuntu:14.04


ENV DEBIAN_FRONTEND noninteractive

# base packages
RUN apt-get update && \
    apt-get -y --quiet upgrade && \
    apt-get -y clean && \
    apt-get -y -q install mariadb-common mariadb-client dbconfig-common libcurl3 libiksemel3 libmysqlclient18 libodbc1 unixodbc libopenipmi0 libsnmp30 libssh2-1 libxml2  wget fping  mysql-common ucf procps iproute





ADD ./zabbix-server/zabbix-server-mysql_2.4.3-1+trusty_amd64.deb /root/zabbix-server-mysql_2.4.3-1+trusty_amd64.deb
RUN dpkg -i /root/zabbix-server-mysql_2.4.3-1+trusty_amd64.deb

# Zabbix Conf Files
ADD ./zabbix-server/zabbix_server.conf	/etc/zabbix/zabbix_server.conf
ADD ./zabbix-server/zabbix_daemon_supervisor.sh /bin/zabbix_daemon_supervisor.sh

RUN chmod +x /bin/zabbix_daemon_supervisor.sh && \
    chmod 640 /etc/zabbix/zabbix_server.conf && \
    chown root:zabbix /etc/zabbix/zabbix_server.conf
#    && \
#    mkdir /var/log/zabbix/ && chown zabbix /var/log/zabbix/



VOLUME ["/var/log/zabbix","/usr/lib/zabbix"]

# Expose the Zabbix Server port 10051
EXPOSE 10051

# Start the custom zabbix_server binary in foreground mode ( -f )
CMD /usr/sbin/zabbix_server -c /etc/zabbix/zabbix_server.conf && /bin/zabbix_daemon_supervisor.sh

