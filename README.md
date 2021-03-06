# Docker LAMP containers for Symfony projects

This composition of containers has been created and tested for Symfony projects but it is usable for more simple php projects or others frameworks.  
Linux and OSX hosts are supported. This set of containers is for development purpose only. It's not usable in a production environment.

## Requirements
Docker engine 1.10.0 or later and Docker compose 1.6.0 or later.

## Install customizable files
The install.sh script copy all customizable files in their destination directories.  
On linux hosts, you should launch it with the user with which you will edit your project files.  
You are free to modify these files to create [your own configuration](#config-files).

    $ ./install.sh

## ACL support
Because it's recommended to use acl on Symfony projects, this composition of containers support it.
While the Docker default filesystem (AUFS) doesn't support ACL, you must use overlay2 on OSX hosts.
Specify the filesystem on docker-machine creation:

    $ docker-machine create --driver=virtualbox --engine-storage-driver=overlay2 your-machine-name

## Named volumes
We use named volumes for keeping data when you destroy and recreate containers.  
Your mysql databases are kept on this way. So are your project files on an OSX host (on a linux host they are stored in the host filesystem).
    
**At this step, the environment is ready for running the containers**

## Create and run containers

    $ docker-compose up -d
    
## Access to provided services
First, find the ips to access to the containers.  
On an OSX host:
    
    $ docker-machine ip your-machine-name # port 80 for your application, 8080 for phpMyAdmin
    
On a linux host:

    $ docker inspect --format '{{ .NetworkSettings.IPAddress }}' apache     # Apache container ip
    $ docker inspect --format '{{ .NetworkSettings.IPAddress }}' phpmyadmin # PhpMyAdmin container ip

### Initialize your database data
Your project needs probably the creation of a database, a specific user...  
SQL Statements required for that should be written in mysql/init.sql.

### Put your project files into the containers
* On an OSX host, project files access is allowed by an AFP share which is more efficient than virtualbox shared folders.  
Reach it on afp://ip_previously_found. Use **www-data** username with **www-data** password for connecting to it.

* On a linux host, project files are accessible in the html-sources folder.

### View your web application
Your project is accessible by typing the url http://ip_previously_found in your browser.

### Symfony CLI ###
The Symfony console (or others CLI commands used by your application) is accessible by creating a new bash session in the apache container.

    $ docker exec -it apache bash
    root@bdae20db89b4:/app# app/console
    
### Use PhpMyAdmin to handle database administration
This set of containers include a PhpMyAdmin container.  
Its url is http://ip_previously_found:8080.
If you haven't modified the file mysql/init.sql, you can login with **root** user with **no password**.

## Install Symfony from scrach ##
Create a new bash session into the apache container:

    $ docker exec -it apache bash

The symfony installer is wrapped by the script /install-sf.sh. This script accept the desired version of Symfony as its first argument.  
Symfony is installed in the /app directory.

    root@bdae20db89b4:/app# /install-sf.sh 2.8 # If no args supplied, latest version is installed
    
Composer is installed too. For instance to install the bundle fos user:    

    root@bdae20db89b4:/app# composer require friendsofsymfony/user-bundle "~2.0@dev"
    
<a name="config-files"></a>
## Configuration files ##
Apache configuration:
* docker_apache/apache2.conf (general configuration)
* docker_apache/000-default.conf (host configuration)
* docker_apache/Dockerfile (installation of libraries needed in the apache container)
* docker_apache/run.sh (execution of commands needed by the apache container, launched after volumes mount, each time the container is started) 
* docker_apache/refresh-acl.sh (if you need to add another user to the acl)

Php configuration:
* docker_apache/php.ini (general configuration)
* docker_apache/apache-20-xdebug.ini and apache/cli-20-xdebug.ini (xdebug configuration for apache and CLI)

Mysql configuration:
* docker_mysql/init.sql (optional database and user creation, executed once when no mysql data exists)
By default, this script create a root user with 'root' as password.

Afp configuration:
* docker_netatalk/afp.conf (afp server configuration)

General configuration:
* docker-compose.yml (containers orchestration)

## Various configurations
* If you work on a non-symfony project, you should modify the DocumentRoot on the apache/000-default.conf file.  
* Symfony best practices recommends to store sensible data in environment variables. Uncomment the concerned lines in apache/000-default.php and apache/run.sh for respecting this practice. 

## Acl problems ##
If you have permission issues, try running the acl permissions script in the apache container:

    $ docker exec apache /refresh-acl.sh

## Third party containers
This set of containers uses the followings:  
  
Tutumcloud MySQL:  
https://github.com/tutumcloud/mysql

Tutumcloud Apache/PHP:  
https://github.com/tutumcloud/apache-php

Corbinu PhpMyAdmin:  
https://github.com/corbinu/docker-phpmyadmin

Cptactionhank Afp server:  
https://github.com/cptactionhank/docker-netatalk

