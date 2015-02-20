# zabbix-server
this docker image will start zabbix-server as detached process ,
. at this moment the only options to run zabbix-server process in foreground is to patch the source
i preferred to setup a simple supervisor for signal forwarding & reading to let the container reflect the process
state and forward container signals to zabbix-server application 




# zabbix confinfugration:
https://www.zabbix.com/documentation/2.4/manual/appendix/config/zabbix_server