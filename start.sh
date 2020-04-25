#!/bin/bash

logs="
logs/admin.00.log
logs/core.00.log
logs/edge.00.log
logs/master.00.log
logs/access.00.log
logs/_defaultVHost_/admin/application.00.log
logs/_defaultVHost_/live/_definst_/application.00.log
logs/_defaultVHost_/livepkgr/_definst_/application.00.log
logs/_defaultVHost_/vod/_definst_/application.00.log
Apache2.4/logs/error_log
Apache2.4/logs/access_log
"

function fifoToStdout {
    while :;do
        tee < $1
    done
}

function fifoToNull {
    while :;do
        cat < $1 > /dev/null
    done
}


for fifo in $logs; do
    dir=`dirname $fifo`
    mkdir -p $dir
    chmod 0777 $dir
    rm -f $fifo # just make sure regular file does not exist
    mkfifo -m 0777 $fifo
    if [[ $fifo == *access* ]] &&
       [ $# -gt 0 ] &&
       [[ $@ == *--disable-access-log* ]]
    then
        fifoToNull $fifo &
    else
        fifoToStdout $fifo &
    fi
done

./amsmgr adminserver start
./server start

sleep infinity
