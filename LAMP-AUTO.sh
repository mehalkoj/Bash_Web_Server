#!/bin/sh
apt-get update
apt-get upgrade -y
apt install apache2 -y
apt install mariadb-server -y
apt install php libapache2-mod-php php-mysql -y
apt install php-curl php-json php-cgi -y
ufw app info "Apache Full"
ufw allow in "Apache Full"
systemctl restart apache2
mkdir /var/www/html/websitedir


# For the time being this creates the non default configuration
file_path="/etc/apache2/sites-available/website.com.conf"



cat <<EOT >> $file_path
<VirtualHost *:80>
        ServerName www.example.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html/websitedir/

        <Directory /var/www/html/websitedir/>

                AllowOverride All

        </Directory>
        
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOT

a2ensite website.com 

// Disable default conf
a2dissite 000-default.conf

apache2ctl configtest
apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap -y
systemctl restart apache2

exit 0