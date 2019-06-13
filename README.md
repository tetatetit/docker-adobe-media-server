# docker-adobe-media-server
A Docker setup for running Adobe Media server

to build the docker container image
```
docker-compose build
```

For debugging, run and start bash
```
docker-compose run ams bash
```

TODO

there are warnings when installing pip:

```
/usr/lib/python2.6/site-packages/pip/_vendor/requests/packages/urllib3/util/ssl_.py:90: InsecurePlatformWarning: A true SSLContext object is not available. This prevents urllib3 from configuring SSL appropriately and may cause certain SSL connections to fail. For more information, see https://urllib3.readthedocs.org/en/latest/security.html#insecureplatformwarning.
  InsecurePlatformWarning
/usr/lib/python2.6/site-packages/pip/_vendor/requests/packages/urllib3/util/ssl_.py:90: InsecurePlatformWarning: A true SSLContext object is not available. This prevents urllib3 from configuring SSL appropriately and may cause certain SSL connections to fail. For more information, see https://urllib3.readthedocs.org/en/latest/security.html#insecureplatformwarning.
  InsecurePlatformWarning
You are using pip version 7.1.0, however version 19.1.1 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
```