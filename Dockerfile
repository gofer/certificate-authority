FROM alpine:latest

# For CRL
EXPOSE 80
EXPOSE 2560
EXPOSE 2561

RUN apk update && apk upgrade \
 && apk install openssl nginx

VOLUME /etc/ssl/test
