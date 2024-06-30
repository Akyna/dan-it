#!/bin/bash

if [[ -d "$1" && -x "$1" ]] && [[ -d "$2" && -x "$2" ]];
then
	cp -fR "$1"/* "$2"/
  	echo "Copied"
else
  echo "Can't copy"
fi
