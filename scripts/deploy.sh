#!/bin/bash
 
# Para mostrar los comandos que se van ejecutando
set -x

# Actualizamos la lista de repositorios
 apt update
# ACtualizamos los paquetes del sistema
# apt upgrade -y

#importamos .env
source .env

#borramos instalaciones previas
rm -rf /tmp/iaw-practica-lamp

#clonamos el repositorio de la aplicacion
git clone https://github.com/josejuansanchez/iaw-practica-lamp /tmp/iaw-practica-lamp

#movemos el codigo fuente de la app /var/www/html
mv /tmp/iaw-practica-lamp/src/* /var/www/html

#configuramos el archivo config.php
sed -i "s/database_name_here/$DB_NAME/" /var/www/html/config.php
sed -i "s/username_here/$DB_USER/" /var/www/html/config.php
sed -i "s/password_here/$DB_PASS/" /var/www/html/config.php

#modificamos el nombre de la bd en el script

sed -i "s/lamp_db/$DB_NAME/" /tmp/iaw-practica-lamp/db/database.sql

#importamos la BD
mysql -u root < /tmp/iaw-practica-lamp/db/database.sql


#creamos el usuario de la bd y le asignamos privilegios
mysql -u root <<< "DROP USER IF EXISTS $DB_USER@'%'";
mysql -u root <<< "CREATE USER $DB_USER@'%' IDENTIFIED BY '$DB_PASS'";
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'%'";

