FROM centos:6.6
MAINTAINER Sarah Allen <sarah@veriskope.com>

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
ENV AMS_VERSION=5_1_5

##############################################################################
# yum install will update lists of available packages
# and install their fresh / current versions.
# Every time we build it  may end up with different package versions
# which is intended for now.
# TODO: after gaining more experience with supervisor, should pin the version
RUN yum update -y                   && \
    yum install -y tar epel-release && \
    yum install -y monit            && \
    yum install -y expect           && \
    yum install -y openssl-devel    && \
    yum clean all

##############################################################################
##### Install media server
WORKDIR /tmp/ams
# RUN yum install -y expect && yum clean all
COPY conf/${AMS_VERSION}/installAMS.input installAMS.input
COPY install.exp .

# note 5.0.15 is labeled .tar.gz but not actually gzipped
RUN curl -O http://download.veriskope.com/AdobeMediaServer5_x64_5.0.15_Linux.tar.gz \
    && tar xvf AdobeMediaServer5_x64_5.0.15_Linux.tar.gz -C . --strip-components=1 \
    && rm -Rf License.txt \
    && sed -i -e 's:read cont < /dev/tty:#read cont < /dev/tty:g' installAMS \
    && sed -i -e 's:/sbin/sysctl:#/sbin/sysctl:g' server \
    && expect install.exp \
    && rm -rf /tmp/ams

##############################################################################
# TODO: Can we conditionalize? if we do this it should be late in the file
# ENV DO_COPY_ADAPTOR_XML=false
#COPY conf/${AMS_VERSION}/Adaptor.xml /opt/adobe/ams/conf/_defaultRoot_/Adaptor.xml

# VOLUME ["/opt/adobe/ams/applications"]

COPY ./dev-tools.sh /tmp/.
RUN /tmp/dev-tools.sh

COPY ./linux-bin/monit* /usr/bin/
COPY /conf/monit.d/* /etc/monit.d/

# Need to map these to host ports with docker run
EXPOSE 80 443 1111 1935

# these are mappped to host ports with docker-compose
CMD ["/usr/bin/monit_start.sh"]
