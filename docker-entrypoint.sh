#!/bin/bash
set -e

touch /picomto-init-complete

#restart Apache
service apache2 stop
apachectl -D FOREGROUND