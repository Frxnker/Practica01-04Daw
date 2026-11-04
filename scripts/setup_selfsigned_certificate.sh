#!/bin/bash
set -ex

source .env

# Crear la clave privada y el certificado autofirmado
openssl req \
  -x509 \
  -nodes \
  -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/ssl/private/apache-selfsigned.key \
  -out /etc/ssl/certs/apache-selfsigned.crt \
  -subj "/C=$OPENSSL_COUNTRY/ST=$OPENSSL_PROVINCE/L=$OPENSSL_LOCALITY/O=$OPENSSL_ORGANIZATION/OU=$OPENSSL_ORGUNIT/CN=$OPENSSL_COMMON_NAME/emailAddress=$OPENSSL_EMAIL"

# Configurar el VirtualHost HTTPS y habilitar SSL
cp ../conf/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
a2ensite default-ssl.conf
a2enmod ssl

# Configurar la redirección de HTTP a HTTPS
cp ../conf/000-default.conf /etc/apache2/sites-available/000-default.conf
a2enmod rewrite

systemctl restart apache2
