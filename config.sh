#!/usr/bin/env bash

sudo apt-get update
ln -s /vagrant /var/www
sudo apt-get install -y apache2 php

htaccess=$(cat <<EOF
RewriteEngine on
RewriteCond     %{REQUEST_SCHEME} ^http$
RewriteRule     ^(.*)$ https://%{SERVER_NAME}%{REQUEST_URI} [L,R]
EOF
)

openssl req -x509 -newkey rsa:4096 -keyout apache.key -out apache.crt -days 365 -nodes -subj "/C=RU/ST=RU/L=RU/O=RU/OU=RU/CN=localhost/emailAddress=sonya.donskaya99@mail.ru"

mkdir /var/www/site1
mkdir /var/www/site2

echo "${htaccess}" > /var/www/site1/.htaccess 
echo "${htaccess}" > /var/www/site2/.htaccess 

mv apache.crt /etc/apache2/server.crt
mv apache.key /etc/apache2/server.key

chmod 400 /etc/apache2/server.key
chmod 400 /etc/apache2/server.crt

SSL_CONF=$(cat <<EOF
<IfModule mod_ssl.c>
<VirtualHost _default_:443>
ServerAdmin sonya.donskaya99@mail.ru
ServerName localhost
DocumentRoot /var/www/site1

ErrorLog /var/www/site1/error.log
CustomLog /var/www/site1/access.log combined

SSLEngine on

SSLCertificateFile /etc/apache2/server.crt
SSLCertificateKeyFile /etc/apache2/server.key

<FilesMatch "\.(cgi|shtml|phtml|php)$">
SSLOptions +StdEnvVars
</FilesMatch>
<Directory /usr/lib/cgi-bin>
SSLOptions +StdEnvVars
</Directory>

</VirtualHost>
</IfModule>
EOF
)

echo "${SSL_CONF}" > /etc/apache2/sites-available/default-ssl.conf

VHOST=$(cat <<EOF
<IfModule mod_ssl.c>
  <VirtualHost localhost:443>
    DocumentRoot "/var/www/site1"
    ServerName localhost
    SSLEngine on
    SSLCertificateFile /etc/apache2/server.crt
    SSLCertificateKeyFile /etc/apache2/server.key
    <FilesMatch "\.(cgi|shtml|phtml|php)$">
    SSLOptions +StdEnvVars
    </FilesMatch>
    <Directory "/var/www/site1">
        AllowOverride All
    SSLOptions +StdEnvVars
    </Directory>
  </VirtualHost>
</IfModule>
EOF
)

echo "${VHOST}" > /etc/apache2/sites-available/default-ssl.conf

VHOST1=$(cat <<EOF
<VirtualHost *:80>
  DocumentRoot "/var/www/site2"
  ServerName localhost
  <Directory "/var/www/site2">
    AllowOverride All
  </Directory>
  Redirect permanent / https://localhost
</VirtualHost>
EOF
)

echo "${VHOST1}" > /etc/apache2/sites-available/000-default.conf

a2enmod actions fastcgi rewrite ssl
a2ensite default-ssl.conf
a2ensite 000-default.conf
service apache2 reload