
# Instalación de php MyAdmin en Debian :computer:

### Configuración de MariaDB :pager:
Para poder crear una autenticación en el servidor de MariaDB también debemos instalar un client para poder asignar los usuarios que se logearan desde php MyAdmin
``` bash
$ apt-get install mariadb-client
```
Comprobamos que el servicio y el cliente estén corriendo correctamente
```bash
$ systemctl status mariadb
```
El log de la consola debe quedar de la siguiente manera
![StatusMariaBD](https://linuxhint.com/wp-content/uploads/2019/08/7-57.png)

En caso que el servicio este desactivado, lo activamos manualmente
```bash
$ systemctl start mariadb
```
Luego de ello le asignaremos una contraseña a **root** para MariaDB :lock:
```bash
$ mysql_secure_installation
```
Se escribe la contraseña deseada, y se le da Yes [Y/n] a todas las configuraciones recomendadas. Con ello está terminada la configuración de MariaDB<br>
![MariaDBSuccess](https://linuxhint.com/wp-content/uploads/2019/08/17-44.png)

### Creación de un usuario para php MyAdmin :bust_in_silhouette:

Primero nos loguearemos al shell de MariaDB
```bash
$ mysql -u root -p
```
Ingresamos la contraseña y estaremos logueados
![LoguedMariaDB](https://linuxhint.com/wp-content/uploads/2019/08/20-41.png)
<br>
Luego de ello, usaremos un comando SQL para asignar un usuario y password para usar php MyAdmin
```sql
GRANT ALL ON *.* TO 'rodrigo'@'localhost' IDENTIFIED BY 'contraseña'
```
Una ves realizado eso, para que el servidor de MariaDB se actualice usamos:
```sql
FLUSH PRIVILEGES;
```
y cerramos el shell de MariaDB con **\q**

### Instalación de las librerías de PHP :file_folder:
Para poder utilizar php MyAdmin necesitamos instalar ciertas librerias, para usar lenguajes de etiquetas tanto como json o xml, usamos el siguiente comando:
```bash
$ apt-get install apache2 php php-json php-mbstring php-zip php-gd php-curl php-xml php-mysql
```
Presionamos **ENTER** y le damos **Yes** a la confirmación de la instalación de los paquetes y debe quedar de la siguiente manera:
![phpLibraries](https://linuxhint.com/wp-content/uploads/2019/08/26-32.png)

### Descarga e instalación de php MyAdmin :floppy_disk:

Instalamos phpMyAdmin primero descargando de una repo externa el zip del programa en su última versión, para ello usaremos:
```bash
$ wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.zip
```
En la carpeta que se descarga el zip, que por defecto es Downloads, haremos unzip al archivo
```bash
$ unzip phpMyAdmin-5.0.2-all-languages.zip -d /opt
```
*Nota: Previamente debe instalar el paquete de Unzip para linux*
```bash
$ apt-get install unzip
```
Luego de extraer el contenido, todo lo extraido debe moverse al directorio www-data para poder acceder al programa
```bash
$ chown - Rfv www-data:www-data /opt/phpMyAdmin
```
y el log debería quedar de la siguiente manera
![phpLogWWWData](https://linuxhint.com/wp-content/uploads/2019/08/39-10.png)

### Configurando Apache para php MyAdmin :space_invader:
Para poder acceder a php MyAdmin de manera local debemos configurar el archivo conf de phpMyAdmin, y configurar el puerto donde se ejecutará localmente
```bash
$ nano /etc/apache2/sites-available/phpmyadmin.conf
```
Una vez abierto el archivo **phpmyadmin.conf** crearemos la instancia al puerto y los logs de error
```html
<VirtualHost *:9000>
ServerAdmin webmaster@localhost
DocumentRoot /opt/phpMyAdmin
 
<Directory /opt/phpMyAdmin>
Options Indexes FollowSymLinks
AllowOverride none
Require all granted
</Directory>
ErrorLog ${APACHE_LOG_DIR}/error_phpmyadmin.log
CustomLog ${APACHE_LOG_DIR}/access_phpmyadmin.log combined
</VirtualHost>
```
Guardamos los cambios y cerramos el archivo de configuracion. Ahora podremos acceder a phpMyAdmin desde el puerto :9000. Para ello debemos declararlo dentro del archivo de puertos en
```bash
$ nano /etc/apache2/ports.conf
```
y agregamos el puerto 9000
![Puerto9000](https://linuxhint.com/wp-content/uploads/2019/08/43-7.png)

Para guardar las configuraciones hechas, ejecutamos finalmente estos comandos
```bash
$ a2ensite phpmyadmin.conf
```
```bash
$ systemctl restart apache2
```

### Accediendo a phpMyAdmin :heavy_check_mark:
Solo debemos acceder de manera local desde el navegador al puerto 9000 y estaremos entrando a phpMyAdmin.
```bash
localhost:9000
```
![phpMyAdmin](https://linuxhint.com/wp-content/uploads/2019/08/46-6.png)

# Instalación de Jupyter Labs :milky_way:
<hr>
En la shell de Debian se debe instalar el paquete de jupyter labs de manera normal usando:
```bash
$ apt-get install jupyterlab
```
Luego de que instala el paquete, ejecutamos el comando de iniciación de la herramienta
```bash
rodrigo@debian:~$ jupyter lab --ip 0.0.0.0 --LabApp.token=''
```
Y finalmente deberiamos entrar desde el navegador de manera local y aparecerá la interfaz gráfica de Jupyter Labs
![JupLabs](https://images.squarespace-cdn.com/content/v1/521e95f4e4b01c5870ce81cf/1522882511035-RTZNGN3SJXUCBSS6BM30/ke17ZwdGBToddI8pDm48kIVBg39eSXCKFVC5h4T1An4UqsxRUqqbr1mOJYKfIPR7LoDQ9mXPOjoJoqy81S2I8N_N4V1vUb5AoIIIbLZhVYxCRW4BPu10St3TBAUQYVKcN_UkRR-3GcESwBHaWf4i2Taax9o3RgkF0Zm1KPmCzr2zo-hOOgsM_tZf3pq2-q3J/1.JPG)

# Configuración de SSH con clave pública y privada :key:

Primero se debe tener instalado en Debian el servidor SSH para ello usamos:
```bash
$ apt-get install openssh-server
```
Por el lado de Windows debemos utilizar PuTTY y PuTTYGen para crear las claves SSH
![Clave1](https://www.codeproject.com/KB/vista-security/497728/PuTTY-Key-Generator-Before-Generate__thumb.png)
Damos Genereate en PuTTYGen para obtener una clave.
![Clave2](https://www.codeproject.com/KB/vista-security/497728/PuTTY-Key-Generator-On-Generate_thum_thumb.png)
Luego la guardaremos como llave privada en cualquier path de nuestro directorio de windows.
Una vez creada la clave y guardada como privada, por el lado de Debian, en la carpeta del usuario verificamos si existe el directorio .ssh
```bash
$ cd .ssh
```
Si no existiera el directorio, lo creamos
```bash
$ mkdir .ssh
$ cd .ssh
```
Una vez creado el directorio, pasamos a crear un archivo de texto simple donde estará la clave generada por PuTTYGen
![Clave3](https://www.codeproject.com/KB/vista-security/497728/PuTTY-Key-Generator-Copy-Public-Key__thumb.png)
En Debian usamos el comando
```bash
$ echo *public_key* >> authorized_keys
```
![Clave4](https://www.codeproject.com/KB/vista-security/497728/Type-Append-to-authorized-keys-file__thumb.png)
Una vez hecho esto, configuramos la conexión y la sesión en PuTTY 
![Clave5](https://www.codeproject.com/KB/vista-security/497728/PuTTY-Configuration-Save-SSH-Auth_th_thumb.png)
En la configuracion de SSH/Auth seleccionamos la clave privada que guardamos anteriormente, de tal manera que al inciar la sesión a Debian desde PuTTY, no nos pida la contraseña y se cree la comunicación entre Windows y Linux
![Clave5](https://www.codeproject.com/KB/vista-security/497728/PuTTY-SSH-Logged-In_thumb2_thumb.png)
Y con eso podemos conectarnos a un servidor Linux/OpenSSH utilizando la Autorizacion de Clave Pública/Privada

```bash
rodrigo@debian:~$ echo Autor: Rodrigo Miguel Quilcat Pesantes
rodrigo@debian:~$ echo Curso: Arquitectura y Administración de Mainframes - Laboratorio
```
