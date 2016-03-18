#!/bin/bash

# Uncomment to use  sensible symfony data in environment variables
#
# if [[ $(cat ~/.bashrc | grep "SYMFONY__") == "" ]]
# then
# echo "export SYMFONY__DATABASE__USER=\"myuser\"" >> ~/.bashrc
# echo "export SYMFONY__DATABASE__PASSWORD=\"mypass\"" >> ~/.bashrc
# echo "export SYMFONY__MAILER__USER=\"mymailuser\"" >> ~/.bashrc 
# echo "export SYMFONY__MAILER__PASSWORD=\"mymailpass\"" >> ~/.bashrc
# fi

chmud u+x /refresh-acl.sh
/refresh-acl.sh

source /etc/apache2/envvars
tail -F /var/log/apache2/* &
exec apache2 -D FOREGROUND
