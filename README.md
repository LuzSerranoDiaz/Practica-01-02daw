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

## Deploy.sh
