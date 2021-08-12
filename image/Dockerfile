FROM alpine:latest

COPY . .

RUN apk --no-cache add openjdk8 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    mkdir -p /opt/app && \
    cp ${APP_NAME}.jar /opt/app/

EXPOSE ${APP_PORT}

CMD ["/bin/sh", "start.sh"]
