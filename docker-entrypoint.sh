#!/bin/bash
set -e

#restart Apache
service apache2 stop
apachectl -D FOREGROUND