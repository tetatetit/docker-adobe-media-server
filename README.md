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

# Testing the server


# Video-on-demand streaming

`vod/media/sample`
sample1_1000kbps.f4v  sample1_150kbps.f4v   sample1_700kbps.f4v
sample1_1500kbps.f4v  sample1_500kbps.f4v   sample.flv


on some platforms, you may need to rebuild curl from source:
```
curl rtmp://localhost:1935/vod/media/sample/sample1_150kbps.f4v
```



# Notes

Experimenting with Monit instead of Supervisor to keep AMS running 
(aka keep the docker container running)

Centos 6.* comes with Python 2.6. Supervisor requires Python 2.7 but we can’t just replace the installed Python with v2.7 because it’s reportedly used by the OS internally.

