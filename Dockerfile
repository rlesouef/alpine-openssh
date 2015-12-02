FROM rlesouef/alpine-base
MAINTAINER Open Source Services [opensourceservices.fr]
# https://github.com/atmoz/sftp

RUN apk --update add \
    openssh && \
    rm -rf /var/cache/apk/*

COPY src/ .

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
