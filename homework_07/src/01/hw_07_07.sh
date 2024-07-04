#!/bin/bash

sudo mkdir web_project

# chown -R root:developers web_project
sudo chgrp developers web_project

sudo chmod g+rw web_project