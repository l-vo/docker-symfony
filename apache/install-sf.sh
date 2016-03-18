#!/bin/bash

if [ -z "$1" ]
then
  symfony new /myapp
else
  symfony new /myapp "$1"
fi

if [[ "$?" == 0 ]]
then
  shopt -s dotglob nullglob
  mv /myapp/* /app
  rm -rf /myapp
  /refresh-acl.sh
fi
