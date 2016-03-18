#!/bin/bash

setfacl -R -m u:www-data:rwX -m u:root:rwX /app
setfacl -dR -m u:www-data:rwX -m u:root:rwX /app
