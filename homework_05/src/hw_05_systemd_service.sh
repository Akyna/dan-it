#!/bin/bash
EXT=back
DIR=~/watch/*

echo "${DIR%\/*}"
if [[ ! -d ${DIR%\/*} ]]; then
	echo "The directory does not exist"
	exit 1
fi

for i in $DIR; do
    if [ "${i}" == "${i%.${EXT}}" ];
	then
		[ -f "$i" ] || continue
#		{
#		  echo "File: $i"
#		  cat "$i"
#		  echo "--------"
#		} >> /var/log/akyna_file_monitor_user.log

		echo "File: $i" >> /var/log/akyna_file_monitor_user.log
		cat "$i" >> /var/log/akyna_file_monitor_user.log
		echo "--------" >> /var/log/akyna_file_monitor_user.log
		mv "$i" "$i".back
    fi
done

