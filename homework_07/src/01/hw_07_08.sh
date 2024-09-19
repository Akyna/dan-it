#!/bin/bash

sudo touch my.log

sudo chmod ugo+w my.log

sudo chattr +a my.log

sudo lsattr my.log