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

to run the server:
```
/opt/adobe/ams/server start
```

Right now you need to stay logged into bash to keep the server running.

TODO:
* Keep the server running with monit
* Make it so LD_LIBRARY_PATH isn't needed (or add to .bashrc or something)

# Testing the server

## Video-on-demand streaming

`rtmpdump` and `curl` are installed for convenience:

```
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib"
ldconfig
rtmpdump -r rtmp://localhost:1935/vod/media/sample.flv -o test.flv
```

or
```
curl rtmp://localhost:1935/vod/media/sample.flv > test.flv
```

troubleshooting:
```
rtmpdump -V -r rtmp://localhost:1935/vod/media/sample.flv -o test.flv
```


# Notes

Experimenting with Monit instead of Supervisor to keep the docker container
running (so AMS will keep running, even when we don't have a bash terminal
open).

Centos 6.* comes with Python 2.6. Supervisor requires Python 2.7 but we can’t just replace the installed Python with v2.7 because it’s reportedly used by the OS internally.

