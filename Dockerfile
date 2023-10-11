FROM alpine:latest

# For CRL
# EXPOSE 80
EXPOSE 2560
EXPOSE 2561

COPY entrypoint.sh /entrypoint.sh

RUN apk update && apk upgrade \
 && apk add openssl

VOLUME /etc/ssl/test

WORKDIR /etc/ssl/test

CMD [ "sh", "/entrypoint.sh" ]
