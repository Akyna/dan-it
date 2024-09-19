#!/bin/bash

# sudo apt update
# WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
# therefore apt-get

echo "Start WEB service"
sudo su -
id -u "${APP_USER}" &>/dev/null || useradd -m -s /bin/bash "${APP_USER}"
usermod -aG sudo "${APP_USER}"
apt-get update -q
apt-get upgrade -y -q
apt-get install openjdk-17-jdk openjdk-17-jre maven git -y -q
echo "--- Java installed --- $(java --version)"
#cat /vagrant/ssh/known_host.txt >> ~/.ssh/known_hosts
cp /vagrant/ssh/* ~/.ssh/
rm -rf /home/"${APP_USER}"/web
mkdir -p /home/"${APP_USER}"/web
#ssh-keygen -F gitlab.com || ssh-keyscan gitlab.com >> ~/.ssh/known_hosts

if ! git clone git@gitlab.com:dan-it/groups/devops5.git "${PROJECT_DIR}"; then
  echo "Clone failed";
else
  echo "Cloned successfully"
  cd "${PROJECT_DIR}"/Module_1/StepProjects/PetClinic || return
  pwd
  mvn clean package
  cp target/*.jar "${PROJECT_DIR}"/web.jar
  cd "${PROJECT_DIR}"/ || return
#  sudo -u "${APP_USER}" nohup java -jar target/*.jar >/dev/null 2>&1 &
#  sudo -u "${APP_USER}" nohup java -jar web.jar >/dev/null 2>&1 &
  sudo -u akyna nohup java -jar \
  -DMYSQL_URL=jdbc:mysql://"${DB_HOST}"/"${DB_NAME}" \
  -DMYSQL_USER="${DB_USER}" \
  -DMYSQL_PASS="${DB_PASS}" \
  -Dspring.profiles.active=mysql web.jar >/dev/null 2>&1 &
fi

echo "Finish WEB service"
