#!/bin/bash

logs="
admin
core
edge
master
access
_defaultVHost_/admin/application
_defaultVHost_/live/_definst_/application
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


for log in $logs; do
    fifo=./logs/$log.00.log
    dir=`dirname $fifo`
    mkdir -p $dir
    chmod 0777 $dir
    rm -f $fifo # just make sure regular file does not exist
    mkfifo -m 0777 $fifo
    if [ $log == access ] &&
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
