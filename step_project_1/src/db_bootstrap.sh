#!/bin/bash

# sudo apt update
# WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
# therefore apt-get
echo "Start MySQL service"
sudo su -
apt-get update -q
#sudo apt-get install mysql-server -y
apt-get install -y -q mysql-server >> install.log
mysql -e "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}'; CREATE DATABASE ${DB_NAME}; GRANT ALL PRIVILEGES ON ${DB_NAME}.* to '${DB_USER}'@'%'; FLUSH PRIVILEGES;" >> install.log 2>&1
sed -i "s/^bind-address.*/bind-address = ${DB_HOST}/" /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql
echo "Finish MySQL service"