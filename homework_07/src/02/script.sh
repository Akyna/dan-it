#!/bin/bash
#
# Monitor disk size
#
REGEXP='^[0-9]+$'
LOG_FILE=/var/log/disk.log
DATE_FORMAT='+%Y-%m-%d %H:%M:%S'

# Check if the ENV variable is set and it's not an empty
#if [ -z "${THRESHOLD// /}" ]; then
#  echo "Вибачте" >&2;
#  exit 1
#fi


if ! [[ $1 =~ $REGEXP ]] ;
then
  echo "[$(date "$DATE_FORMAT")]: Вибачте THRESHOLD є не корректним значенням" >> $LOG_FILE;
  exit 1
fi

DISK_USAGE=$(df -h --output=pcent / | awk '{print $1/1}' | tail -n -1)

if (( "$DISK_USAGE" > "$1" )); then
    echo "[$(date "$DATE_FORMAT")]: Місце на диску менше чим $1%" >> $LOG_FILE;
fi

#THRESHOLD_NUMBER=$((THRESHOLD))

#if [ $THRESHOLD_NUMBER -gt 23 ]; then
#    echo "..."
#fi