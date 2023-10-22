FROM odoo:16.0

ENV BACKUP_DIR=/backup

USER root

RUN apt-get update && apt-get install -y \
    cron \
    tini \
    && rm -rf /var/lib/apt/lists/*

ADD *.sh /scripts/
RUN chmod a+x /scripts/*

ENTRYPOINT ["tini", "--", "/scripts/entry.sh"]
