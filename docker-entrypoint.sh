#!/bin/bash
set -e

#Configure PHP
sudo sed -i 's/^post_max_size.*=.*/post_max_size = 1024M/g' /etc/php5/apache2/php.ini
sudo sed -i 's/^upload_max_filesize.*=.*/upload_max_filesize = 1024M/g' /etc/php5/apache2/php.ini
sudo sed -i 's/^max_file_uploads.*=.*/max_file_uploads = 100/g' /etc/php5/apache2/php.ini
sudo sed -i 's/.*date.timezone.*=.*/date.timezone = \"Europe\/Paris\"/g' /etc/php5/apache2/php.ini

#Configure APACHE2
a2enmod headers
a2enmod rewrite

#Configure Ioncube
wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
tar -xvzf ioncube_loaders_lin_x86-64.tar.gz
#cp ioncube/ioncube_loader_lin_5.5.so /usr/lib/php/20151012
#echo "zend_extension = /usr/lib/php/20121212/ioncube_loader_lin_5.5.so" > /etc/php5/apache2/conf.d
#echo "zend_extension = /usr/lib/php/20121212/ioncube_loader_lin_5.5.so" > /etc/php5/cli/conf.d
#rm ioncube -Rf

#restart Apache
service apache2 stop
apachectl -D FOREGROUND