#!/bin/bash

echo -n "Enter file name: "
read -r file_name
if [ -f "$file_name"  ]; then
  echo "File exists"
  else
    echo "File doesn't exist."
fi
