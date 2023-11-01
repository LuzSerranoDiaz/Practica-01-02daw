# Practica-01-02daw
# Creacion de instancia en OpenStack

![instancias](https://github.com/LuzSerranoDiaz/Practica-01-02daw/assets/125549381/cb6ec693-303b-4bea-b9ea-75ae71bdee5f)

Se crea una instancia de Ubuntu 23.04 con sabor m1.medium para que no haya errores con la memoria ram.

![clave](https://github.com/LuzSerranoDiaz/Practica-01-02daw/assets/125549381/41dd7bcc-a631-4323-a825-813bd2620d8a)

Se utiliza el par de claves ya utilizado.

![SecurityGroup](https://github.com/LuzSerranoDiaz/Practica-01-02daw/assets/125549381/649d64bb-5727-49a7-8932-cee79d389bf4)

Se añaden excepciones en el grupo de seguridad para los puertos 22(SSH), 80(HTTP) y 443(HTTPS), y ICMP.

# Documento tecnico practica 1 despliegue de aplicaciones web DAW

En este documento se presentará los elementos para instalar LAMP, junto otras herramientas y modificaciones.

## Install_lamp.sh
```bash
#!/bin/bash
 
#Para mostrar los comandos que se van ejecutando
set -ex

#Actualizamos la lista de repositorios
apt update
#Actualizamos los paquetes del sistema
#apt upgrade -y

#Instalamos el servidor APACHE
sudo apt install apache2 -y

#Instalamos MYSQL SERVER
apt install mysql-server -y

#Instalar php 
sudo apt install php libapache2-mod-php php-mysql -y

#Copiamos archivo de configuracion de apache
cp ../conf/000-default.conf /etc/apache2/sites-available

#Reiniciamos servicio apache
systemctl restart apache2

#Copiamos el archivo de prueba de PHP
cp ../php/index.php /var/www/html

#Cambiamos usuario y propietario de var/www/html
chown -R www-data:www-data /var/www/html
```
En este script se realiza la instalación de LAMP en la última version de **ubuntu server** junto con la modificación del archivo 000-default.conf, para que las peticiones que lleguen al puerto 80 sean redirigidas al index encontrado en /var/www/html
### Como ejecutar Install_lamp.sh
1. Abre un terminal
2. Concede permisos de ejecución
 ```bash
 chmod +x install_lamp.sh
 ```
 o
 ```bash
 chmod 755 install_lamp.sh
 ```
 3. Ejecuta el archivo
 ```bash
 sudo ./install_lamp.sh
 ```
## .env
```bash
DB_NAME=lamp_db
DB_USER=lamp_user
DB_PASS=lamp_pass
```
## Deploy.sh
```bash
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

```
Se realizan los pasos premeditarios:
1. Actualizar repositorios
2. Se importa .env
3. Se borran instalaciones previas en el directorio temporal por defecto de ubuntu para que no de error
4. Clonamos el repositorio de la aplicación web
```

#movemos el codigo fuente de la app /var/www/html
mv /tmp/iaw-practica-lamp/src/* /var/www/html

#configuramos el archivo config.php
sed -i "s/database_name_here/$DB_NAME/" /var/www/html/config.php
sed -i "s/username_here/$DB_USER/" /var/www/html/config.php
sed -i "s/password_here/$DB_PASS/" /var/www/html/config.php

#modificamos el nombre de la bd en el script
sed -i "s/lamp_db/$DB_NAME/" /tmp/iaw-practica-lamp/db/database.sql
```
1. Se mueve el codigo fuente del repositorio temporal al repositorio final
2. Utilizando el comando sed configuramos el archivo config.php ya que por defecto tiene nombre de bd, nombre de usuario y contraseña de prueba  
  2.1 En el archivo config.php donde la cadena "database_name_here" se cambia a la variable $DB_NAME
   
   2.2 En el archivo config.php donde la cadena "username_here" se cambia a la variable $DB_USER
   
   2.3 En el archivo config.php donde la cadena "password_here" se cambia a la variable $DB_PASS
   
3. Se hace lo mismo en el archivo database.sql
   
   3.1 En el archivo database.sql donde la cadena "lamp_db" se cambia a la variable $DB_NAME, que en nuestro caso se llamaba de por si lamp_db pero por si queremos cambiar la base de datos en el futuro
      
```bash
#importamos la BD
mysql -u root < /tmp/iaw-practica-lamp/db/database.sql

#creamos el usuario de la bd y le asignamos privilegios
mysql -u root <<< "DROP USER IF EXISTS $DB_USER@'%'";
mysql -u root <<< "CREATE USER $DB_USER@'%' IDENTIFIED BY '$DB_PASS'";
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'%'";

```
1. Se importa la base de datos con el comando mysql y el parametro '<' para que utilice las instrucciones dentro del archivo
2. Se crea el usuario y se le asigna todos los privilegios en la base de datos utilizando el comando mysql y el parametro '<<<' para inyectar directamente una cadena de instrucciones
