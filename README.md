# docker-adobe-media-server
A Docker setup for running Adobe Media server

This is a work-in-progress -- docker container installs the server, but
doesn't actually run it yet (see "notes" below).

to build the docker container image
```
docker-compose build
```

For debugging, run and start bash
```
docker-compose run ams bash
```


# Notes

Experimenting with Monit instead of Supervisor to keep AMS running 
(aka keep the docker container running)

Centos 6.* comes with Python 2.6. Supervisor requires Python 2.7 but we can’t just replace the installed Python with v2.7 because it’s reportedly used by the OS internally.

