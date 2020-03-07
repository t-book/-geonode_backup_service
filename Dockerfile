FROM python:3.7.6-alpine3.11
MAINTAINER toni.schoenbuchner@csgis.de

# 1-2. Install system dependencies (we only need the pg_dump binary from postgresql, other dependencies are in postgresql-client)
RUN apk add --no-cache postgresql-client && \
    apk add --no-cache --virtual BUIID_DEPS postgresql && \
    cp /usr/bin/pg_dump /bin/pg_dump && \
    apk add --no-cache curl && \
    apk add --no-cache findutils && \
    curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip && \
    unzip rclone-current-linux-amd64.zip && \
    cp rclone-*-linux-amd64/rclone /usr/bin && \
    rm -rf rclone-* && \
    apk del BUIID_DEPS

# envsubst dependency
RUN apk add --no-cache gettext tzdata
ENV TZ Europe/Amsterdam

# The entrypoint creates the certificate
ADD crontab crontab.envsubst
ADD docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

# We run cron in foreground
CMD ["/usr/sbin/crond", "-f"]
