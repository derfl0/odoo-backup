#!/bin/sh

echo "Starting backup at $(date)"

# create a backup
curl -s -X POST \
    -F "master_pwd=${ADMIN_PASSWORD}" \
    -F "name=${ODOO_DATABASE}" \
    -F "backup_format=zip" \
    -o ${BACKUP_DIR}/${ODOO_DATABASE}.$(date +%F_%H%M%S).zip \
    ${URL}/web/database/backup

# delete old backups
find ${BACKUP_DIR} -type f -mtime +8 -name "${ODOO_DATABASE}.*.zip" -delete

echo "Finished backup"