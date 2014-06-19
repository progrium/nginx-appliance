FROM ubuntu:trusty
MAINTAINER Jeff Lindsay <progrium@gmail.com>

RUN echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu trusty main" > /etc/apt/sources.list.d/nginx.list

RUN apt-get update && apt-get install -y --force-yes nginx ruby1.9.1
RUN rm -rf /etc/nginx/conf.d /etc/nginx/sites-available /etc/nginx/sites-enabled
RUN echo "include /etc/nginx/docker.include; events { }" > /etc/nginx/nginx.conf

ADD https://github.com/progrium/configurator/releases/download/v0.0.2/configurator_0.0.2_linux_x86_64.tgz /tmp/configurator.tgz
RUN cd /bin && tar -zxf /tmp/configurator.tgz && rm /tmp/configurator.tgz

ADD https://raw.githubusercontent.com/progrium/configurator/v0.0.2/transformers/nginx-conf /bin/nginx-conf
RUN chmod +x /bin/nginx-conf

ADD ./docker.include /etc/nginx/docker.include
ADD ./default.json /tmp/default.json
ADD ./start /start

EXPOSE 80 9000

CMD ["/start"]