#!/bin/bash
# https://blog.deimos.fr/2016/01/13/docker-why-you-should-use-monit-instead-of-supervisord/

# Catch signals
trap "/usr/bin/monit_stop_all_wait.sh ; exit" EXIT

# Monit will start all apps
service monit start

# Stay up for container to stay alive
while [ 1 ] ; do
   sleep 1d
done
