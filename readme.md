# Odoo Backup Docker

A very easy approach to odoo backup via curl

## How to

This docker container automates the download of an Odoo backup via the Odoo DB Manager. Simply mount /backup into the container to store backups

## Environment

| EnvVar | Description |
| --- | --- |
| BACKUP_DIR | Rewrite the backup directory inside the container |
| ODOO_DATABASE | Define the name of the Odoo database to backup |
| ADMIN_PASSWORD | Masterpassword of the instance  |
| URL | URL where the instance is available |
| SCHEDULE | Cronscheduler for the backup (e.g. */30 * * * * ) |
| DELETE_AFTER | Delete old backups after **n** days |

## Restore after backup
If you have a staging environment and want to restore the captured backup once the job is finished, use:

| EnvVar | Description |
| --- | --- |
| RESTORE_URL | URL of the staging environment |
| RESTORE_DATABASE | The target database for the restore. **DANGER!** the previous database will be dropped automatically **without** a backup. |
| RESTORE_ADMIN_PASSWORD | Admin password for the url |
