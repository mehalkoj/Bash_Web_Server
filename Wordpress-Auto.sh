#!/bin/sh
read -p "Enter Website Name / Website Dir: " web_name
read -p "Enter Database User: " db_name
read -p "Enter Database Password: " db_password


apt-get update
apt-get upgrade -y
apt install apache2 -y
apt install mariadb-server -y
apt install php libapache2-mod-php php-mysql -y
apt install php-curl php-json php-cgi -y
ufw app info "Apache Full"
ufw allow in "Apache Full"
systemctl restart apache2
mkdir /var/www/html/$web_name


# For the time being this creates the non default configuration
file_path="/etc/apache2/sites-available/$web_name.conf"



cat <<EOT >> $file_path
<VirtualHost *:80>
        ServerName www.example.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html/$web_name/wordpress

        <Directory /var/www/html/$web_name/wordpress>

                AllowOverride All

        </Directory>
        
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOT

a2ensite $web_name.com 

// Disable default conf
a2dissite 000-default.conf

apache2ctl configtest

mysql -u root < wp_creation.sql

systemctl restart apache2

cd /var/www/html/$web_name/
wget http://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
chown -R www-data:www-data /var/www/html/$web_name
cd /var/www/html/$web_name/wordpress/
cp wp-config-sample.php wp-config.php

sed -i "s/database_name_here/wordpress/g" wp-config.php
sed -i "s/username_here/$db_name/g" wp-config.php
sed -i "s/password_here/$db_password/g" wp-config.php

apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap -y
systemctl restart apache2

exit 0