#!/bin/bash

echo -n "Enter your name: "
IFS=' ' read -r name
echo "Hello $name"
