#!/bin/bash

docker create --name data-mysql -v /var/lib/mysql -v /flags debian:jessie data-mysql
