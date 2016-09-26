FROM alpine:latest

MAINTAINER Open Source Services [opensourceservices.fr]

RUN apk --update add \
    openssh && \
    rm -rf /var/cache/apk/*

COPY src/ .

EXPOSE 22

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
