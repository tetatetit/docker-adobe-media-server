# TODO: Can we conditionalize? Maybe something like --> https://github.com/icy/bocker
#ENV CENTOS_TAG=6.6
#FROM centos:${CENTOS_TAG}
FROM centos:6.6
MAINTAINER Jun Heider<jun@realeyes.com>

#### Download links
# http://download.macromedia.com/pub/adobemediaserver/5_0_10/AdobeMediaServer5_x64.tar.gz
# http://download.macromedia.com/pub/adobemediaserver/5_0_9/AdobeMediaServer5_x64.tar.gz
# http://download.macromedia.com/pub/adobemediaserver/5_0_8/AdobeMediaServer5_x64.tar.gz
# http://download.macromedia.com/pub/adobemediaserver/5_0_7/AdobeMediaServer5_x64.tar.gz
# http://download.macromedia.com/pub/adobemediaserver/5_0_6/AdobeMediaServer5_x64.tar.gz
# http://download.macromedia.com/pub/adobemediaserver/5_0_5/AdobeMediaServer5_x64.tar.gz
# 5.0.3 is different - http://download.macromedia.com/pub/adobemediaserver/AdobeMediaServer5_x64.tar.gz
ENV AMS_VERSION=5_0_8
ENV DO_YUM_UPDATE=true
ENV DO_COPY_CERTS=false
ENV DO_COPY_ADAPTOR_XML=false

RUN rpm --import https://getfedora.org/static/0608B895.txt

RUN if ${DO_YUM_UPDATE} == 'true'; then yum update -y; fi  
RUN yum install -y tar python-setuptools
RUN easy_install supervisor

RUN mkdir -p /var/log/supervisor
COPY conf/supervisord.conf /etc/supervisord.conf

WORKDIR /tmp
RUN curl -O http://download.macromedia.com/pub/adobemediaserver/${AMS_VERSION}/AdobeMediaServer5_x64.tar.gz
WORKDIR /tmp/ams_${AMS_VERSION}
RUN tar zxvf ../AdobeMediaServer5_x64.tar.gz -C . --strip-components=1
RUN rm -Rf License.txt
RUN sed -i -e 's:read cont < /dev/tty:#read cont < /dev/tty:g' installAMS

COPY conf/${AMS_VERSION}/installAMS.input installAMS.input

RUN ./installAMS < installAMS.input
# TODO: Can we conditionalize?
#COPY certs /opt/adobe/certs
#COPY conf/${AMS_VERSION}/Adaptor.xml /opt/adobe/ams/conf/_defaultRoot_/Adaptor.xml

# CLEANUP
WORKDIR /tmp
RUN rm -Rf ams_${AMS_VERSION} AdobeMediaServer5_x64.tar.gz

VOLUME ["/opt/adobe/ams/applications"]

# Need to map these to host ports with docker run
EXPOSE 80 443 1111 1935

# See if we rework this to also start ams 
CMD ["/usr/bin/supervisord"]
