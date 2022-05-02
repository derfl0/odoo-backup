#!/bin/sh

if [ ! -z "$SCHEDULE" ]; then
    echo "Renew crontab"
    echo "${SCHEDULE} /scripts/backup.sh" > /crontab.txt
    /usr/bin/crontab /crontab.txt
    echo "Start cron"
    /usr/sbin/crond -f -l 2
else
    echo "Run once"
    /scripts/backup.sh
fi