#!/bin/bash

ZABBIX_PIDFILE="/var/log/zabbix/zabbix_server.pid"

# @info
# used to find processes state (workaround for never-garbaged-zombie issue )
# @param
#  $1 = process id
# @return
#     "Z" if process is zombie
#      or  something else
getProcessStateFromId(){
    local PROC_ID=$1
    echo $( ps -o pid,state --pid $PROC_ID --no-headers | awk '{print $2}' )
}


checkPidExist() {
    local PID_TO_CHECK=$1
    if [[ $PID_TO_CHECK -lt "1" ]]; then
        echo 'pid ( '$PID_TO_CHECK' ) not found ' >&2
        echo "false"
        return 0
    fi
    local ZOMBIE_PROCESS_STATE='Z'
    kill -0 $PID_TO_CHECK 1>/dev/null 2>&1
    if [[ $? -eq "0" ]]; then #process id exists
        echo 'checking process state for id , '$PID_TO_CHECK' , state = '$( getProcessStateFromId $PID_TO_CHECK)'' >&2
        [[ $( getProcessStateFromId $PID_TO_CHECK) == "${ZOMBIE_PROCESS_STATE}" ]] && echo "false" || echo "true"
    else
        echo "false"
    fi
}


get_zabbix_pid(){
[ -f $ZABBIX_PIDFILE ] && {
cat $ZABBIX_PIDFILE
} || {
echo ${ZABBIX_PIDFILE}' is not a file' >&2
}

}


clean_up() {
# Perform program exit housekeeping
echo '[TRAPPED] '$1'closing program, pid =  '$$;
kill -s $1 $(getProcessStateFromId)
sleep 1
exit 0
}

# capture signals
trap "clean_up SIGHUP" SIGHUP
trap "clean_up SIGINT" SIGINT
trap "clean_up SIGTERM" SIGTERM
trap "clean_up SIGKILL" SIGKILL


#ZABBIX_PID=$(get_zabbix_pid)
#echo 'waiting zabbix process to start pid: '$ZABBIX_PID   >&2
#pidRunning=$( checkPidExist $ZABBIX_PID )
#echo 'pidRunning = '$pidRunning   >&2


#++ NB: there is a scope issue overwriting global variable from a until-loop ( so variables must be reassigned inside and outside of the loops)


while true
do
    ZABBIX_PID=$(get_zabbix_pid)
    pidRunning=$( checkPidExist $ZABBIX_PID )
    echo 'waiting zabbix process to start pid: '$ZABBIX_PID' , pidRunning = '$pidRunning    >&2
    [[ "$pidRunning" == "true" ]] && break
    sleep 0.3
done


while true
do
    ZABBIX_PID=$(get_zabbix_pid)
    pidRunning=$( checkPidExist $ZABBIX_PID )

    [[ "$pidRunning" == "false" ]] && {
        echo 'process died: '$ZABBIX_PID' , pidRunning = '$pidRunning    >&2
        break
    } || {
        sleep 1 ;
    }

done

