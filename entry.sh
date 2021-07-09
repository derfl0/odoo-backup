#!/bin/sh

echo "Renew crontab"
echo "${SCHEDULE} /scripts/backup.sh" > /crontab.txt
/usr/bin/crontab /crontab.txt

echo "Start cron"
/usr/sbin/crond -f -l 2