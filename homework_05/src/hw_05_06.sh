#!/bin/bash

read -rp "Enter a sentence: " TEXT_INPUT

if [ -z "${TEXT_INPUT}" ]; then
    echo "Empty input. Bye bye..."
    exit 1
fi

list=( $TEXT_INPUT )
for i in $(seq $((${#list[@]} - 1)) -1 0); do
    echo "${list[$i]}"
done | xargs
