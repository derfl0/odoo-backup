FROM odoo:16.0

ENV BACKUP_DIR=/backup

USER root

ADD --chown=odoo:odoo *.sh /scripts/
RUN chmod a+x /scripts/*

USER odoo

ENTRYPOINT ["/scripts/entry.sh"]
