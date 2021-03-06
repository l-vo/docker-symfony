#!/bin/bash

echo -e "\\033[0;39mInstallation started ..."
cd "$(dirname "$0")"

# check existance and copy a customable file to its destination folder
function copyFile()
{
  file="$1"
  dir="$2"

  if [ -z "$3" ]
  then
    dest="$file"
  else
    dest="$3"
  fi

  if [ -e ./"$dir"/"$dest" ]
  then
    echo -e "\\033[1;31m- $dest already exists in $dir: no file copied"
  else
    cp ./customizable-files/"$file" ./"$dir"/"$dest"
    echo -e "\\033[1;32m+ $dest copied in $dir"
  fi
}

# Apache files
copyFile "000-default.conf" "docker_apache"
copyFile "apache2.conf" "docker_apache"
copyFile "apache-20-xdebug.ini" "docker_apache"
copyFile "cli-20-xdebug.ini" "docker_apache"
copyFile "apache-php.ini" "docker_apache"
copyFile "cli-php.ini" "docker_apache"
copyFile "run.sh" "docker_apache"
copyFile "refresh-acl.sh" "docker_apache"
copyFile "Dockerfile" "docker_apache"

# Mysql files
copyFile "init.sql" "docker_mysql"

# Afp files
copyFile "afp.conf" "docker_netatalk"

# Check if we are on an OSX host
if [[ $(uname -s) == "Darwin" ]]
then
  osx=1
else
  osx=0
fi

# docker-compose.yml
if [[ "$osx" == 1  ]]
then
  copyFile "docker-compose.osx.yml" "." "docker-compose.yml"
else
  copyFile "docker-compose.linux.yml" "." "docker-compose.yml"
fi

# On linux hosts, add current user sur to the acl grants
if [[ "$osx" == 0 ]]
then
  id=$(id -u)
  if [[ $(cat apache/refresh-acl.sh | grep "u:$id") == "" ]]
  then 
    sed -i -e "s/-m u:www-data:rwX/-m u:$id:rwX -m u:www-data:rwX/g" apache/refresh-acl.sh
    echo -e "\\033[1;32m+ user id $id added to the acl grants"
  fi
fi

echo -e "\\033[0;39mInstallation completed."
