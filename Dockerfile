FROM gliderlabs/alpine:3.3
MAINTAINER Open Source Services [opensourceservices.fr]
# https://github.com/atmoz/sftp

RUN apk --update add \
    openssh && \
    rm -rf /var/cache/apk/*

COPY src/ .

EXPOSE 22

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
