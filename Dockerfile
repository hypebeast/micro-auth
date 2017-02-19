FROM openresty/openresty:xenial

MAINTAINER Sebastian Ruml <sebastian@sebastianruml.name>

RUN apt-get install -y libssl-dev

RUN /usr/local/openresty/luajit/bin/luarocks install lapis
RUN /usr/local/openresty/luajit/bin/luarocks install penlight

RUN mkdir /app

WORKDIR /app

ADD ./app /app

ENV LAPIS_OPENRESTY "/usr/local/openresty/bin/openresty"

EXPOSE 8080

ENTRYPOINT ["/usr/local/openresty/luajit/bin/lapis"]

CMD ["server", "production"]
