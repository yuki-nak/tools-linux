#!/bin/bash

export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=$ORACLE_BASE/product/19c/dbhome_1 
export LISTENER_NAME=LISTENER

LOG_FILE=./logs/restartlog.txt

# Get listener's status
LISTENER_STATUS=$($ORACLE_HOME/bin/lsnrctl status $LISTENER_NAME | grep "The command completed successfully" | wc -l)

# Recovery action
if [ $LISTENER_STATUS -eq 0 ]; then
    echo "Listener is down. restarting..."
    $ORACLE_HOME/bin/lsnrctl start $LISTENER_NAME 2>&1
    if [ $? -eq 0 ]; then
        echo "Listener restarted successfully."
        echo "Listener restarted at $(date)" >> $LOG_FILE
    else
        echo "Failed to restart."
        echo "Failed to restart at $(date)" >> $LOG_FILE
    fi
else
    echo "Listener is already running."
fi

#Set cron job for execution every one minute.
#* * * * * . $HOME/.bashrc; /home/oracle/restart_listener.sh