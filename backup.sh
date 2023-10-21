#!/bin/bash

function create_web_backup () {
    echo "Backup via web"

    # create a backup
    curl -s -S -X POST \
        -F "master_pwd=${ADMIN_PASSWORD}" \
        -F "name=${ODOO_DATABASE}" \
        -F "backup_format=zip" \
        -o ${BACKUP_NAME} \
        ${URL}/web/database/backup
}

function restore_web_backup () {

    echo "Restoring backup"

    # find latest backup
    #BACKUP_FILE=$(ls -t ${BACKUP_DIR} | head -1)
    #BACKUP_PATH="${BACKUP_DIR}/${BACKUP_FILE}"

    # drop previous db
    curl -s -S -X POST \
        -F "master_pwd=${RESTORE_ADMIN_PASSWORD}" \
        -F "name=${RESTORE_DATABASE}" \
        -L \
        ${RESTORE_URL}/web/database/drop

    # sleep to make sure db got deleted
    sleep 1

    # restore backup
    curl -s -S -X POST \
        -F "master_pwd=${RESTORE_ADMIN_PASSWORD}" \
        -F "backup_file=@${BACKUP_NAME}" \
        -F 'copy=true' \
        -F "name=${RESTORE_DATABASE}" \
        ${RESTORE_URL}/web/database/restore

    echo "Restoring backup completed"
}

function create_db_backup () {
    echo "Backup via Odoo access"

    export PGPASSWORD="${DB_PASSWORD}"
    odoo db --db_host ${DB_HOST} -r ${DB_USER} -w ${DB_PASSWORD} dump ${ODOO_DATABASE} ${BACKUP_NAME}

}

function restore_db_backup () {
    echo "Restore via Odoo access"

    # find latest backup
    BACKUP_FILE=$(ls -t ${BACKUP_DIR%/}/*.zip | head -1)
    # BACKUP_PATH="${BACKUP_DIR}/${BACKUP_FILE}"

    echo "Will restore $BACKUP_FILE"
    odoo db --db_host ${RESTORE_HOST} -r ${RESTORE_USER} -w ${RESTORE_PASSWORD} load --force ${RESTORE_DB} ${BACKUP_FILE}

}

echo "Starting backup at $(date)"
cd $BACKUP_DIR
BACKUP_FOLDER_NAME=${ODOO_DATABASE}.$(date +%F_%H%M%S)
BACKUP_NAME=${BACKUP_DIR}/${ODOO_DATABASE}.$(date +%F_%H%M%S).zip

# check if direct db backup
if [ ! -z "$DB_HOST" ]; then
    create_db_backup
fi

# check if web backup
if [ ! -z "$URL" ]; then
    create_web_backup
fi

# delete old backups
if [ ! -z "$DELETE_AFTER" ]  && [ "$DELETE_AFTER" -gt 0 ] ; then
    echo "Deleting old backups"
    find ${BACKUP_DIR} -type f -mtime +${DELETE_AFTER} -name "${ODOO_DATABASE}.*.zip" -delete
fi

cd $BACKUP_DIR

# If we want to restore the database as well
if [ ! -z "$RESTORE_URL" ] ; then
    restore_web_backup
fi

if [ ! -z "$RESTORE_DB" ] ; then
    restore_db_backup
fi
