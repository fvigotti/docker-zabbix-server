FROM fvigotti/fatubuntu

ENV DEBIAN_FRONTEND noninteractive


RUN apt-get install software-properties-common && \
  apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && \
  add-apt-repository 'deb ftp://ftp.ulak.net.tr/pub/MariaDB/repo/10.0/ubuntu trusty main' && \
  apt-get -y --quiet update  && \
  apt-get -y -q install mariadb-common mariadb-client dbconfig-common libcurl3 libiksemel3 libmysqlclient18 libodbc1 unixodbc libopenipmi0 libsnmp30 libssh2-1 libxml2  wget fping  mysql-common ucf procps iproute



# install zabbix server
ADD ./zabbix-server/zabbix-server-mysql_2.4.3-1+trusty_amd64.deb /root/zabbix-server-mysql_2.4.3-1+trusty_amd64.deb
RUN dpkg -i /root/zabbix-server-mysql_2.4.3-1+trusty_amd64.deb

# Zabbix Conf Files
ADD ./zabbix-server/zabbix_server.conf	/etc/zabbix/zabbix_server.conf

ADD scripts /scripts


RUN chmod +x /scripts/supervisor.sh && \
    chmod 640 /etc/zabbix/zabbix_server.conf && \
    chown root:zabbix /etc/zabbix/zabbix_server.conf

#    && \



VOLUME ["/var/log/zabbix","/usr/lib/zabbix"]

# Expose the Zabbix Server port 10051
EXPOSE 10051

# Start the custom zabbix_server binary in foreground mode ( -f )
CMD ["/scripts/supervisor.sh"]

