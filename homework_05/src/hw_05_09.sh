#!/bin/bash
read -rp "Enter a file name: " FILE_NAME

if [ ! -f "$FILE_NAME" ];
then
    echo "Sorry, the file does not exist."
else
	cat "$FILE_NAME"
	echo
fi
