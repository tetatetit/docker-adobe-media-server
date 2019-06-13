FROM centos:6.9
MAINTAINER Sarah Allen<sarah@veriskope.com>

#### Manual install instructions
# https://helpx.adobe.com/adobe-media-server/install/install-media-server.html

#### Download links
# http://download.macromedia.com/pub/adobemediaserver/5_0_10/AdobeMediaServer5_x64.tar.gz
# http://download.macromedia.com/pub/adobemediaserver/5_0_9/AdobeMediaServer5_x64.tar.gz
# http://download.macromedia.com/pub/adobemediaserver/5_0_8/AdobeMediaServer5_x64.tar.gz
# http://download.macromedia.com/pub/adobemediaserver/5_0_7/AdobeMediaServer5_x64.tar.gz
# http://download.macromedia.com/pub/adobemediaserver/5_0_6/AdobeMediaServer5_x64.tar.gz
# http://download.macromedia.com/pub/adobemediaserver/5_0_5/AdobeMediaServer5_x64.tar.gz
# 5.0.3 is different - http://download.macromedia.com/pub/adobemediaserver/AdobeMediaServer5_x64.tar.gz
ENV AMS_VERSION=5_0_8
ARG BUILD_ENV=TOOLS
 
##############################################################################
##### Install media server
WORKDIR /tmp/ams
RUN yum install -y expect
COPY conf/${AMS_VERSION}/installAMS.input installAMS.input
COPY install.exp .
RUN curl -O https://download.macromedia.com/pub/adobemediaserver/${AMS_VERSION}/AdobeMediaServer5_x64.tar.gz \
    && tar zxvf AdobeMediaServer5_x64.tar.gz -C . --strip-components=1 \
    && rm -Rf License.txt \
    && sed -i -e 's:read cont < /dev/tty:#read cont < /dev/tty:g' installAMS \
    && sed -i -e 's:/sbin/sysctl:#/sbin/sysctl:g' server \
    && expect install.exp \
    && rm -rf /tmp/ams

COPY conf/${AMS_VERSION}/Adaptor.xml /opt/adobe/ams/conf/_defaultRoot_/Adaptor.xml

# VOLUME ["/opt/adobe/ams/applications"]

# these are mappped to host ports with docker-compose
EXPOSE 80 443 1111 1935

# WORKDIR /opt/adobe/ams

