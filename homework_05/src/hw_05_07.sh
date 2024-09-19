#!/bin/bash
read -rp "Enter a file name: " FILE_NAME

if [ ! -f "$FILE_NAME" ]; then
    echo "The file does not exist. Bye..."
    exit 1
fi

count=0
while IFS= read -r list || [[ -n $list ]]; do
	((count+=1))
done < "$FILE_NAME"

echo "$count"
