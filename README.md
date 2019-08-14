# docker-adobe-media-server
A Docker setup for running Adobe Media server

This is a work-in-progress -- docker container installs the server, but
doesn't actually run it yet (see "notes" below).

By default, a trial version of the Adobe Media Server will be installed.
If you have a license file, copy into the folder `lic`.

to build the docker container image
```
docker-compose build
```

Run and start bash (we will be running the server from here). Note: We have to use --service-ports because by default, the [`docker-compose run` command does not map ports](https://docs.docker.com/compose/reference/run/).
```
docker-compose run --service-ports ams bash
```

to run the server:
```
/opt/adobe/ams/server start
```

Although the output says:

> Starting Adobe Media Server (please check /var/log/messages)

the actual location of the logs is `/opt/adobe/ams/logs/`. There are several log files.

Right now you need to stay logged into bash to keep the server running (see TODO below).

TODO:
* Currently we use `docker-compose run` instead of `docker-compose up` because docker expects whatever is run in the container to send information to stdout/stderr, but AMS writes log files instead (similar to nginx, apache, and many others). There are a few ways to redirect logfiles to stdout/stderr, including tools like [dockerize](https://github.com/jwilder/dockerize).
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

## Troubleshooting

Test whether ports are open to docker container


To test whether you can connect to AMS, you can download the sample.flv file using this command:
```
rtmpdump -V -r rtmp://localhost:1935/vod/media/sample.flv -o test.flv
```
If you want to check against the original, you can copy it using this command:
```
docker cp <container id>:/opt/adobe/ams/applications/vod/media/sample.flv ./sample.flv
```
sample.flv and test.flv should be identical.

## Additional tools

send sample file to `live` app via ffmpeg (not installed)
```
ffmpeg -i sample.flv -f flv "rtmp://localhost:1935/live/your_stream_id"
```
or
```
ffmpeg -i sample.flv -f flv "rtmps://localhost:1935/live/your_stream_id"
```
or
```
ffmpeg -i sample.flv -f flv "rtmpt://localhost:1935/live/your_stream_id"
```

> Tested on ffmpeg v3.4.6 in official [Ubuntu 18.04](https://hub.docker.com/_/ubuntu?tab=tags)
while v2.8.15 in [Ubuntu 16.04](https://hub.docker.com/_/ubuntu?tab=tags) did not work with RTMPS
