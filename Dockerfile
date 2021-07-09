FROM alpine:latest

RUN apk add --no-cache tini curl

ENV BACKUP_DIR=/backup
ENV ODOO_DATABASE=odoo
ENV ADMIN_PASSWORD=admin
ENV URL=localhost:8069
ENV SCHEDULE="*/30 * * * *"

ADD *.sh /scripts/
RUN chmod a+x /scripts/*

ENTRYPOINT ["/sbin/tini", "--", "/scripts/entry.sh"]
