#!/bin/sh

if [ ! -z "$SCHEDULE" ]; then
    echo "Renew crontab"
    env > /crontab.txt
    echo "${SCHEDULE} /scripts/backup.sh >/proc/1/fd/1 2>/proc/1/fd/2" >> /crontab.txt
    /usr/bin/crontab /crontab.txt
    echo "Start cron"
    /usr/sbin/cron -f -l 2
else
    echo "Run once"
    /scripts/backup.sh
fi