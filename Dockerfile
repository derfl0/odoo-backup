FROM alpine:latest

RUN apk add --no-cache tini curl zip postgresql-client

ENV BACKUP_DIR=/backup
# ENV ODOO_DATABASE=odoo
# ENV ADMIN_PASSWORD=admin
# ENV URL=localhost:8069
#ENV SCHEDULE="*/30 * * * *"
ENV FILESTORE_DIR=/filestore

ADD *.sh /scripts/
RUN chmod a+x /scripts/*

ENTRYPOINT ["/sbin/tini", "--", "/scripts/entry.sh"]
