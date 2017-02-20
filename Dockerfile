FROM openresty/openresty:alpine-fat

MAINTAINER Sebastian Ruml <sebastian@sebastianruml.name>

RUN apk add --update \
    openssl-dev bash \
    && rm /var/cache/apk/*

RUN /usr/local/openresty/luajit/bin/luarocks install lapis
RUN /usr/local/openresty/luajit/bin/luarocks install penlight

RUN mkdir /app

WORKDIR /app

ADD ./app /app

ENV LAPIS_OPENRESTY "/usr/local/openresty/bin/openresty"

EXPOSE 8080

ENTRYPOINT ["/app/entrypoint.sh"]

CMD ["server", "production"]
