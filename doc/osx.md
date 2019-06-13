# Notes on OSX tools for working with RTMP

```
brew install rtmpdump
git clone https://github.com/curl/curl.git
cd curl 
./buildconf
./configure --with-darwinssl
make 
make install
````

Now curl is available in `/usr/local/bin/curl`


```
/usr/local/bin/curl rtmp://localhost/vod/media/sample.flv

```