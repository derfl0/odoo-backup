#!/bin/sh

echo "Starting backup at $(date)"

# create a backup
BACKUP_NAME=${BACKUP_DIR}/${ODOO_DATABASE}.$(date +%F_%H%M%S).zip
curl -s -X POST \
    -F "master_pwd=${ADMIN_PASSWORD}" \
    -F "name=${ODOO_DATABASE}" \
    -F "backup_format=zip" \
    -o ${BACKUP_NAME} \
    ${URL}/web/database/backup

# delete old backups
if [ -n $DELETE_AFTER ]  && [ $DELETE_AFTER -gt 0 ] ; then
    echo "Deleting old backups"
    find ${BACKUP_DIR} -type f -mtime +${DELETE_AFTER} -name "${ODOO_DATABASE}.*.zip" -delete
fi

echo "Finished backup"

# If we want to restore the database as well
if [ -n $RESTORE_URL ] ; then

    echo "Restoring backup"

    # find latest backup
    #BACKUP_FILE=$(ls -t ${BACKUP_DIR} | head -1)
    #BACKUP_PATH="${BACKUP_DIR}/${BACKUP_FILE}"

    # drop previous db
    curl -s -X POST \
        -F "master_pwd=${RESTORE_ADMIN_PASSWORD}" \
        -F "name=${RESTORE_DATABASE}" \
        ${RESTORE_URL}/web/database/drop > /dev/null

    # restore backup
    curl -s -X POST \
        -F "master_pwd=${RESTORE_ADMIN_PASSWORD}" \
        -F "backup_file=@${BACKUP_NAME}" \
        -F 'copy=true' \
        -F "name=${RESTORE_DATABASE}" \
        ${RESTORE_URL}/web/database/restore > /dev/null

    echo "Restoring backup completed"

fi
