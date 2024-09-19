#!/bin/bash

RANDOM_NUMBER=$((1 + RANDOM % 10))
ATTEMPTS=5
REGEXP='^[0-9]+$'

echo "$RANDOM_NUMBER"
echo "Вгадайте число від 1 до 10. У Вас є 5 спроб"
while [ $ATTEMPTS -gt 0 ]; do
    read -rp "Введіть число: " number
    # Check if it's a number
    if ! [[ $number =~ $REGEXP ]] ;
    then
      echo "Вибачте Ви ввели не число" >&2;
      exit 1
    fi

    if [ "$number" -eq $RANDOM_NUMBER ];
    then
      echo "Вітаємо! Ви вгадали правильне число";
      exit 0
    elif [ "$number" -gt $RANDOM_NUMBER ];
    then
      echo "Занадто високо"
    else
      echo "Занадто низько"
    fi
    # Reduction of attempts
    ((ATTEMPTS--))
done

echo "Вибачте, у вас закінчилися спроби. Правильним числом було $RANDOM_NUMBER"

# We can use brake instead of exit 0
# In this case we need check attempts quantity
#if [ $ATTEMPTS -eq 0 ]; then
#  echo "Вибачте, у вас закінчилися спроби. Правильним числом було $RANDOM_NUMBER"
#fi


