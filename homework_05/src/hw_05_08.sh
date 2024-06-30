#!/bin/bash
fruits=("Apple" "Banana" "Orange" "Pineapple")

for key in "${!fruits[@]}"
do
  echo "Key for fruits array is: $key"
done

for value in "${fruits[@]}"
do
  echo "Value for fruits array is: $value"
done

for key in "${!fruits[@]}"
do
  echo "Key is '$key'  => Value is '${fruits[$key]}'"
done
