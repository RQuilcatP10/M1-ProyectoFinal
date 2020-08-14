# Análisis de Sentimientos en los tweets acerca de la vacuna rusa contra el COVID-19
##### Trabajo Final de Curso 2020-10
##### Universidad Privada Antenor Orrego
##### Facultad de Ingeniería
##### Escuela Profesional de Ingeniería de Computación y Sistemas
---
## GENERALIDADES
El trabajo final es un producto software que desarrolla el ciclo de vida de un proyecto de ciencia de datos, para el cual, el equipo desarrollador seleccionó el tema de "Análisis de Sentimientos" para demostrar dicho ciclo de vida.
Se usará la herramienta cloud Google Colab el cual soporta y se basa en los Notebooks de Jupyter, que permite el uso gratuito de GPUs y TPUs, todo bajo el lenguaje Python en su versión 2.7 y 3.6
#### CASO DE ESTUDIO: VACUNA CONTRA EL COVID :microscope:
<p style='text-align: justify;'> El mundo actualmente vive una crisis sanitaria a causa del virus SARS-Cov-2 o más conocido como coronavirus (COVID-19) el cual ha puesto en una situación dificil a casi la totalidad de países, cuyo objetivo desde el inicio de esta pandemia fue hallar la vacuna para contrarrestar dicho virus. Actualmente en el mes de agosto aproximadamente van una totalidad de 20,2 millones de casos de contagio y más de 741.000 muertos en todo el mundo. De manera local, en Perú vamos un aproximado de 483 mil casos de contagio, y 21.000 fallecidos. <br> El día 11 de Agosto del 2020, el presidente de la Federación Rusa, Vladímir Putin, declaro a la prensa mundial que Rusia ya tiene una vacuna aprobada y registrada contra el coronavirus, el cual fue desarrollado por el Instituto Gamaleya y fue registrada después de dos meses de ensayos en humanos. Dado el caso, en redes sociales, a nivel mundial, se vino criticando o aplaudiendo dicho logro por parte de Rusia y su presidente. A demás declaran que por una parte es poco confiable, hay muchas dudas y descubrimientos por hacer, mientras que muchos países en el mundo estan decididos a comprarle a Rusia dichas vacunas en el menor tiempo posible, ya que actualmente se están produciendo en masa.<br> Como analistas de datos, queremos determinar que tan confiable puede ser esta vacuna, y cuantos prefieren no opinar o estar en contra de dicha vacuna, para ello nos basaremos en los comentarios que se realicen dentro de la red social Twitter, la cual es una gran fuente de datos para poder extraer dicha información, y a su vez, nos permitirá hacer una exploración del ciclo de vida de un proyecto de ciencia de datos.</p>

#### ANÁLISIS DE SENTIMIENTOS :fearful: :smile: :anguished: :rage:
<p style='text-align: justify;'> El Análisis de Sentimientos es un área de investigación enmarcada dentro del campo del Procesamiento del Lenguaje Natural y cuyo objetivo fundamental es el tratamiento computacional de opiniones, sentimientos y subjetividad en textos. En este contexto, una opinión es una valoración positiva o negativa acerca de un producto, servicio, organización, persona o cualquier otro tipo de ente sobre la que se expresa un texto determinado.</p>

#### PROCESAMIENTO DE LENGUAJE NATURAL :speech_balloon:
<p style='text-align: justify;'>El procesamiento del lenguaje natural, abreviado PLN​​ —en inglés natural language processing, NLP— es un campo de las ciencias de la computación, inteligencia artificial y lingüística que estudia las interacciones entre las computadoras y el lenguaje humano.</p>

## CICLO DE VIDA DE CIENCIA DE LOS DATOS
### RECOLECCIÓN DE DATOS :open_file_folder:
Para la fase de recolección de datos, usaremos la red social Twitter, la cual nos permitirá extraer la información con respecto a los tweets que realizan los usuarios. Esto será posible con la afiliación del usuario al programa Developers de Twitter.

![TwitterDeveloper](https://github.com/RQuilcatP10/M1-ProyectoFinal/blob/master/Otros/M1Imagen1.PNG)

Dentro de ello, crearemos un proyecto, el cual nos servirá para crear keys, y con ello acceder y usar la API de Twitter para la extracción de los datos

![TwitterDeveloper2](https://github.com/RQuilcatP10/M1-ProyectoFinal/blob/master/Otros/M1Imagen2.PNG)
![TwitterDeveloper2](https://github.com/RQuilcatP10/M1-ProyectoFinal/blob/master/Otros/M1Imagen3.PNG)

Una vez con esto creado y validado, procedemos realizar la extracción de la data conveniente, para ello, presentaremos dos formas para hacerlo.

#### A) PRIMER MÉTODO DE RECOLECCIÓN: SCRIPT EN PYTHON - GOOGLE COLAB
Creamos un notebook en Google Colab (véase en <b>Codigo/Datos/Recoleccion de Datos.ipynb</b>) aquí importaremos las siguientes librerías:

```python
import tweepy #Librería para usar la API de twitter para desarrolladores
import pandas as pd #Librería para usar dataframes visualmente amigables
import csv #Libreria para el manejo de archivos csv
import preprocessor as p #Libreria para limpiar los tweets
from unidecode import unidecode #Libreria para manejar caracteres españoles
```
Previamente tendremos un archivo .csv con nuestras keys de Twitter Developer para poder hacer uso de la librería tweepy y crear la api de busqueda y extracción de tweets (véase en <b>Codigo/Configuraciones/Twitter_Credentials.csv</b>), hacemos uso de la librería <b>Pandas</b> para leer el archivo csv y hacer uso de su contenido de la siguiente manera:

```python
#Usamos pandas para leer el csv y extraer las credenciales
log = pd.read_csv('Twitter_Credentials.csv')
#Twitter API credenciales de desarrollador
consumer_key = log['key1'][0]
consumer_secret = log['key2'][0]
access_token = log['key3'][0]
access_token_secret = log['key4'][0]
```
Con esas variables definidas procedemos a crear un objeto de autenticación para el uso de la API de Twitter, a través de un handler llamado OAuthHandler, el cual nos permitira autenticarnos. Para ello primero declaramos una variable de autenticación la cual recibe como parametros la key del usuario, tanto la key pública como la key secreta.
```python
#Creamos el objeto de autenticacion
autenticacion = tweepy.OAuthHandler(consumer_key, consumer_secret)
```
A nuestro objeto de autenticación le consederemos los permisos de acceso a la API, para poder crear la API que usaremos para la busqueda y extracción de tweets
```python
#Configuramos el token de acceso
autenticacion.set_access_token(access_token, access_token_secret)
```
Y por ultimo creamos nuestra API para realizar las tareas de recolección, la cual recibe como parametros el objeto autenticación que hemos creado anteriormente, y a su vez le decimos que nos permita realizar consultas respetando el límite que nos ofrece el plan free developer de Twitter. (Si no declaramos dicho parametro como True, nos generará errores luego de cierto tiempo de haber usado la API)
```python
#Creamos el objeto API para obtener acceso a la información
api = tweepy.API(autenticacion, wait_on_rate_limit = True)
```
Con esto configurado, procedemos a crear el script que hará la recolección y escritura en archivo .csv de los tweets de un determinado tema, en un determinado tiempo y en un determinado límite de items.
```python
#Reemplazamos la palabra tema por el caso de estudio
#Caso 1: vacuna_rusa.csv
#Caso 2: voto_confianza.csv
csvFileRaw = open('tema.csv', 'a')
csvWriterRaw = csv.writer(csvFileRaw)

#Para recolectar los tweets, usaremos un objeto Cursor, el cual hará el trabajo de paginar los tweets según los parametros que le mandemos
#El parametro api.search significa que hará una busqueda
#El parametro q recibe lo que queremos buscar, desde un usuario, tendencia, hashtag, etc. En nuestro caso usaremos:
# Putin -> Tendencia
# #VotodeConfianza -> Hashtag
#El parametro count hace referencia al maximo resultado por página con respecto al tweet buscado, con un count de 100 haremos 100 llamadas al servicio por minuto, para evitar exeder de golpe el limite de 5000 consultas que nos da tweepy
#El parametro lang hace referencia al lenguaje del tweet, donde para el primer caso sera "en" por ser un tema globar, mientras que para el segundo será "es" por ser un tema local.
#El parametro sice hace referencia a la fecha de busqueda inicial hacia la actual
#El parametro tweet_mode hace referencia a la cantidad de caracteres que querramos traer con el script, puede ser short para traer un maximo de 7 palabras por tweet o extended para traer el tweet completo
for tweet in tweepy.Cursor(api.search, q="Tendencia - Hashtag", count=100, lang="en", since="2020-08-07",tweet_mode="extended").items():
    #Hacemos un print para ver que nos trae la API
    print(tweet.created_at, tweet.full_text)
    #Hacemos escritura de lo extraido en el csv declarado anteriormente, solo guardaremos la fecha de creacion y el texto del tweet para la demo
    csvWriterRaw.writerow([tweet.created_at, tweet.full_text])
```
El resultado que obtendremos es el siguiente:

![CSV](https://github.com/RQuilcatP10/M1-ProyectoFinal/blob/master/Otros/M1Recoleccion1.PNG)

#### B) SEGUNDO MÉTODO DE RECOLECCIÓN: USO DE GOOGLE SHEETS ADD ONS
El primer método de recolección al ser un script se tendría que ejecutar cada vez que el notebook sea abierto, por lo que la recolección se hará mas corta en cuanto a items, por los periodos de tiempo. Una alternativa a esto, es el uso de GOOGLE SHEET y TWITTER ARCHIVER, que es un complemento que nos agiliza la recolección de datos, organizandolos automaticamente en forma de tabla, listo para exportar como archivo .csv, y a demás de eso se va llenando de forma automática cada 1 hora, llenando de 100 registros dicho archivo. Esto agiliza mas la recolección, ya que a mas datos, mejor serán los modelos a implementar mas adelante. Para ello también usaremos la cuenta de Twitter Developers que creamos al comienzo de esta fase.
Lo primero será ingresar a la GSuite de Google y buscar: "Twitter Archiver", lo descargamos e instalamos.

![TwitterArchiver](https://github.com/RQuilcatP10/M1-ProyectoFinal/blob/master/Otros/M1Recoleccion2.PNG)

Una vez instalado, procedemos a crear un nuevo archivo vacío en Google Sheets, y dentro nos aparecerá el menú COMPLEMENTOS, abrimos, seleccionamos Twitter Archiver y creamos una nueva regla de busqueda, ahí nos darán la opcion de ingresar un hashtag, palabra clave, tendencia, etc. Además de otros campos como el lenguaje, locación, fecha.

![TwitterArchiverC](https://github.com/RQuilcatP10/M1-ProyectoFinal/blob/master/Otros/M1Recoleccion3.png)

Cuando hayamos ingresado los parametros de busqueda, empezará automaticamente a llenar un template predeterminado para esto con la data requerida (fecha, usuario, nombre de usuario, texto del tweet, id del tweet, media, locación, usuario verificado, biografía del usuario, fecha de creación del usuario) para un análisis de datos y poder pasar a la siguiente fase del ciclo de vida.

![TwitterArchiverA](https://github.com/RQuilcatP10/M1-ProyectoFinal/blob/master/Otros/M1Recoleccion4.PNG)
---
### MODELADO ESTRUCTURADO DE DATOS :chart_with_upwards_trend:
#### A) MODELADO DE LA BASE DE DATOS
Según el dataset que usaremos, modelaremos la base de datos para albergar la información recolectada en el archivo .csv, para ellos analizaremos los campos que este contiene, y con ello procedemos a identificar:
1. Se pueden crear 2 tablas a partir del dataset los cuales son:
    * <b><u>USUARIO</u></b> :arrow_right: Hace referencia al usuario de twitter, aqui se puede guardar el usuario, nombre real del usuario, número de personas a que sigue, número de personas que le siguen, fecha de creación, locación (sin ubigeo completo), y una descripción.
    * <b><u>TWEETS</u></b> :arrow_right: Hace referencia al tweet que realiza un determinado usuario, este contendrá el usuario que lo creo, la fecha de publicación, el ID del tweet, el tweet textual, nro de retweets, favoritos, dispositivo desde el que se realizo.

2. El modelo se ve muy simple a primera vista, por lo que se le aplico normalización, de tal manera de crear una estructura basada en master-detail, entonces cada tabla se dividirá en 2, una tabla maestra con su respectivo detalle quedando de la siguiente manera:
    * <b><u>USUARIO</u></b> :arrow_right: Hace referencia al usuario de Twitter, solo se guardará el userID y el nombre real del usuario.
    * <b><u>USUARIO_DETALLE</u></b> :arrow_right: Aquí se guardarán la cantidad de followers, las personas a las que sigue, fecha de creación, locación, biografía. El objetivo de la tabla es servir como un log de cambios de estados del usuario, por el momento solo guardaremos la información brindada por el dataset.
    * <b><u>TWEET</u></b> :arrow_right: Hace referencia al tweet que publica un determinado usuario, se guardará dicho usuario, el texto del tweet, fecha de creación, el IDTweet.
    * <b><u>TWEET_DETALLE</u></b> :arrow_right: Hace referencia a los detalles del tweet, se guardarán los retweets (a futuro se podría guardar el usuario que retweeteo), quienes dieron favorito (a futuro se podría guardar el usuario que dio like), la aplicación desde donde se realizó el Twitter.

Teniendo en cuenta esta estructura, el modelo quedará de la siguiente manera:
![ModeloBD](https://github.com/RQuilcatP10/M1-ProyectoFinal/blob/master/Otros/M1ModeloEstructurado1.PNG)
#### B) IMPLEMENTACIÓN DE LA BASE DE DATOS
En esta parte, para el proyecto hemos hecho las siguientes consideraciones:
>   1. Se hará uso de una base de datos alojada en SQL Server, creada con un servicio en Amazon Web Services.
>   2. Se hará uso del dataset para dividirlo y formar archivos .csv para insertarlos a través de la función BULK de SQL.
>   3. Al no contar con un servidor de alojamiento de base de datos fisico, primero crearemos la base de datos de manera local y también en el servidor creado, esto con el fin de crear un script que crea el esquema, las tablas, y los registros, y lo ejecutaremos usando Python.

Para poder crear una instancia en SQL Server, donde está alojado nuestra base de datos, debemos insalar lo siguiente para poder conectarnos al servidor

```bash
#Crear e instalar instancia de Microsoft SQL Server 2017 para Linux
%%sh
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get -q -y install msodbcsql17

# Añadir paquetes de ODBC para Linux
!sudo apt-get install unixodbc-dev

# Instala el paquete de pyodbc para conectarnos y usar la base de datos desde python
!pip install pyodbc
```
Con todo esto instalado y configurado crearemos una instancia y una conexion a la base de datos. Para ello usaremos <b>PYODBC</b> para crear un objeto conexion y un objeto Cursor, los cuales nos permitiran realizar scripts SQL a través de strings.

```python
import pandas as pd
import pyodbc
conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};'
                      'YOUR DATABASE SERVER'
                      'Database=YOUR DATABASE;'
                      'UID=YOUR ID;'
                      'PWD=YOUR PASSWORD;'
                      'TDS_Version=8.0;'
                      'Port=YOIR PORT;')
cursor = conn.cursor()
```
El esquema de base de datos se puede crear de dos formas, la primera es ejecuando un script schema de SQL Server, para ello PYODBC nos permite hacer lo siguiente

```python
with open('M1SQLPoblacion.sql', 'r', encoding='utf-8',errors='ignore') as inserts:
  for statement in inserts:
    print(statement)
    cursor.execute(statement)
```

O la otra manera es creando las tablas manualmente, en nuestro caso procedemos a hacer lo siguiente:

```python
script_Sql = "STRING CREATE TABLE HERE"
cursor.execute(script_Sql)
conn.commit()
```

En el string, cambiaremos "STRING CREATE TABLE HERE" por el siguiente esquema SQL

```SQL
CREATE TABLE Usuarios(
	ScreenName varchar(100) NOT NULL PRIMARY KEY,
	FullName varchar(100)
)

CREATE TABLE Usuarios_Detalle(
	ScreenName VARCHAR(100) FOREIGN KEY REFERENCES Usuarios(ScreenName), 
	Followers INT, 
	Follows INT, 
	UserSince DATE, 
	Location VARCHAR(200), 
	Bio VARCHAR(MAX)
)

CREATE TABLE Tweets (
	Date_Tweet DATE, 
	TweetText VARCHAR(MAX), 
	TweetID BIGINT NOT NULL PRIMARY KEY, 
	ScreenName varchar(100) FOREIGN KEY REFERENCES Usuarios(ScreenName)
)

CREATE TABLE Tweets_Detalle(
	TweetID BIGINT FOREIGN KEY REFERENCES Tweets(TweetID),
	Retweets INT, 
	Favorites INT, 
	App VARCHAR(100)
)
```
Una vez creado nuestro esquema, podemos ingresar a nuestro servidor para realizar la inserción con un archivo .csv para ello, nuestro dataset principal obtenida de GoogleSheets, la exportaremos, y dividremos en distintos dataframes para crear archivos .csv y con eso ejecutar un script SQL para insertar datos

```python
data = pd.read_csv('covid_russia_vaccine_twits.csv')

# Creamos los dataframes
usuarios = pd.DataFrame(data[['Screen Name', 'Full Name']])
usuarios_detalle = pd.DataFrame(data[['Screen Name', 'Followers', 'Follows', 'User Since', 'Location.1', 'Bio']])
tweets = pd.DataFrame(data[['Date', 'Tweet Text', 'Tweet ID', 'Screen Name']])
tweets_detalle = pd.DataFrame(data[['Tweet ID', 'Retweets', 'Favorites', 'App']])

#Creamos el .csv con el siguiente formato
dataframename.to_csv('archivo_name.csv', index=False, sep=";")
```

Y una vez terminado esto, ingresamos al servidor y ejecutamos el siguiente script SQL

```sql
create table UsuariosCsv(
	ScreenName varchar(100),
	FullName varchar(100)
)
BULK INSERT UsuariosCsv
FROM 'pathFile'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)
Insert into Usuarios(ScreenName,FullName) SELECT ScreenName,FullName from UsuariosCsv
drop table UsuariosCsv
--select * from Usuarios
/*******************************************************/
create table Usuarios_DetalleCsv(
	ScreenName VARCHAR(100), 
	Followers INT, 
	Follows INT, 
	UserSince DATE, 
	Location VARCHAR(200), 
	Bio VARCHAR(MAX)
)
BULK INSERT Usuarios_DetalleCsv
FROM 'pathFile'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)
Insert into Usuarios_Detalle(ScreenName, Followers,Follows,UserSince,Location,Bio) SELECT ScreenName, Followers,Follows,UserSince,Location,Bio from Usuarios_DetalleCsv
drop table Usuarios_DetalleCsv
/*******************************************************/
create table TweetsCsv(
	Date_Tweet DATETIME, 
	TweetText VARCHAR(MAX), 
	TweetID BIGINT, 
	ScreenName varchar(100)
)
BULK INSERT TweetsCsv
FROM 'pathFile'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)
Insert into Tweets(Date_Tweet,TweetText,TweetID,ScreenName) SELECT Date_Tweet,TweetText,TweetID,ScreenName from TweetsCsv
drop table TweetsCsv
--select * from TweetsCsv
/************************************************************/
create table Tweets_DetalleCsv(
	TweetID BIGINT,
	Retweets INT, 
	Favorites INT, 
	App VARCHAR(100)
)
BULK INSERT Tweets_DetalleCsv
FROM 'pathFile'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)
Insert into Tweets_Detalle(TweetID,Retweets,Favorites,App) SELECT TweetID,Retweets,Favorites,App from Tweets_DetalleCsv
drop table Tweets_DetalleCsv
```
Con eso terminamos la creación y poblamiento de nuestra base de datos basado en el dataset generado.
