FROM mini/base
MAINTAINER Jeff Lindsay <progrium@gmail.com>

RUN apk update && apk-install bash nginx ruby ruby-json
RUN rm -rf /etc/nginx/conf.d /etc/nginx/sites-available /etc/nginx/sites-enabled
RUN echo "include /etc/nginx/docker.include; events { }" > /etc/nginx/nginx.conf

ADD https://github.com/progrium/configurator/releases/download/v0.0.3/configurator_0.0.3_linux_x86_64.tgz /tmp/configurator.tgz
RUN cd /bin && tar -zxf /tmp/configurator.tgz && rm /tmp/configurator.tgz

ADD https://raw.githubusercontent.com/progrium/configurator/v0.0.3/transformers/nginx-conf /bin/nginx-conf
RUN chmod +x /bin/nginx-conf
RUN mkdir -p /tmp/nginx

ADD ./docker.include /etc/nginx/docker.include
ADD ./default.json /tmp/default.json
ADD ./start /start

EXPOSE 80 9000

CMD ["/start"]