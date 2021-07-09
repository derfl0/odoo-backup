# Odoo Backup Docker

A very easy approach to odoo backup via curl

## How to

This docker container automates the download of an Odoo backup via the Odoo DB Manager. Simply mount /backup into the container to store backups

## Environment

**BACKUP_DIR**
Rewrite the backup directory inside the container

**ODOO_DATABASE**
Define the name of the Odoo database to backup

**ADMIN_PASSWORD**
Masterpassword of the instance

**URL**
URL where the instance is available

**SCHEDULE**
Cronscheduler for the backup (e.g. */30 * * * * )