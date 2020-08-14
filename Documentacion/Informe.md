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

### CONSULTAS EXPLORATORIAS A LOS DATOS :floppy_disk:

En esta fase veremos a través de distintos scripts la data almacenada en nuestra base de datos anteriormente creada, para ello tenemos 2 sencillos pasos de realizar.
Por un lado tenemos los siguientes scripts seleccionados por nosotros:

```sql
--1. Consulta exploratoria a Tweets
	SELECT TOP 10 * FROM Tweets 
--2. Consulta exploratoria a Usuarios
	SELECT * FROM Usuarios
--3. Consulta exploratoria al detalle de usuario
	SELECT TOP 10 * FROM Usuarios_Detalle
--4. Consulta exploratoria al detalle de tweets
	SELECT TOP 10 * FROM Tweets_Detalle
--5. Seleccionar el detalle de un Usuario especifico
	SELECT * FROM Usuarios_Detalle WHERE ScreenName = '@adaptiveoptics'
--6. Seleccionar los tweets pertenecientes a un Usuario especifico
	SELECT * FROM Tweets WHERE ScreenName = '@adaptiveoptics'
--7. Ordenar Usuarios por fecha de creación
	SELECT FullName FROM Usuarios ORDER BY FullName ASC
--8. Ordenar Usuarios por nombres que empiecen con la letra 'A'
	SELECT Fullname FROM Usuarios WHERE FullName LIKE '[A]%' ORDER BY FullName ASC
--9. Exploración de cuantos usuarios tienen una cuenta sin una locación asociada
	SELECT COUNT(*) as SinLocation FROM Usuarios_Detalle WHERE Location IS NULL
--10. Seleccion de Usuario con mayor Numero de seguidores
	SELECT * FROM Usuarios_Detalle WHERE Followers = (SELECT MAX(Followers) FROM Usuarios_Detalle)
--11. Seleccion de Usuarios con menor Numero de seguidores
	SELECT * FROM Usuarios_Detalle WHERE Followers = (SELECT MIN(Followers) FROM Usuarios_Detalle)
--12. Seleccion de la info completa de un tweet
	SELECT * FROM Tweets t INNER JOIN Tweets_Detalle td on td.TweetID = t.TweetID
--13. Seleccion de los usuarios mas antiguos
	SELECT TOP 1 u.FullName, u.ScreenName, ud.UserSince, ud.Location FROM Usuarios u INNER JOIN Usuarios_Detalle ud ON u.ScreenName = ud.ScreenName ORDER BY UserSince ASC
--14. Seleccion del usuario mas reciente
	SELECT TOP 1 u.FullName, u.ScreenName, ud.UserSince, ud.Location FROM Usuarios u INNER JOIN Usuarios_Detalle ud ON u.ScreenName = ud.ScreenName ORDER BY UserSince DESC
--15. Seleccion del total de plataformas mas utilizada para twitear
	SELECT App, COUNT(App) as Total FROM Tweets_Detalle GROUP BY App ORDER BY Total DESC
--16. Seleccion del top 1 de plataforma mas usada
	SELECT TOP 1 App, COUNT(App) as Total FROM Tweets_Detalle GROUP BY App ORDER BY Total DESC
--17. Seleccion del top 1 de plataforma menos usada
	SELECT TOP 1 App, COUNT(App) as Total FROM Tweets_Detalle GROUP BY App ORDER BY Total ASC
--18. Seleccion del Tweet con mas retweets
	SELECT t.TweetText, t.Date_Tweet FROM Tweets_Detalle td INNER JOIN Tweets t on t.TweetID = td.TweetID WHERE Retweets = (SELECT MAX(Retweets) FROM Tweets_Detalle)
--19. Seleccion de los tweets entre los dias lunes 10 y martes 11
	SELECT TweetText FROM Tweets WHERE Date_Tweet BETWEEN '08-10-2020' AND '08-12-2020'
```

Y por otro lado tenemos en Python una conexion a PYODBC, instalada en la fase anterior, y para cada una de las consultas listadas solo es necesario seguir el siguiente formato:

```python
cons_nro = pd.read_sql_query("SCRIPT PERTENECIENTE AL NRO", conn)
cons_nro
```

### PREPARACIÓN DE LOS DATOS :pager:

1. Importamos word_tokenize, stopwords, PorterStemmer y TextBlob
> NLTK es una librería especializada en Lenguaje Natural, por lo que nos permite hacer procesamiento de texto para clasificación, tokenización, derivación, etiquetado, análisis de sentimientos etc.
> <br> **word_tokenize:** Nos permite dividir una cadena (string) en substrings: por ejemplo "Este es un texto" a ["esto", "es", "un", "texto"]
> <br> **stopwords:** Nos permite eliminar palabras innecesarias de un texto
> <br> **PorterStemmer:** Es un algoritmo que quita sufijos de las palabras, de tal manera que la palabra quede en su estado primitivo, o raiz, por lo que fasilitaría la clasificación ya que en un tweet podriamos repetir una sola raiz, mas no la misma palabra.
> <br> **TextBlob:** Es una librería de análisis de sentimientos, donde permite realizar el calculo de subjectividad y polaridad de una frase completa sin tener que cortar la cadena en subcadenas, sirve para crear datasets de entrenamiento

```python
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer
from textblob import TextBlob
import pandas as pd
import re
```

Crearemos unas funciones para determinar los niveles de polaridad y subjetividad:

```python
#Esta función devuelve la subjectividad que determina del tweet completo
#Subjetividad: Se refiere a una medida objetiva que no involucra sentimiento
#Los posibles valores van de 0 a 1
def getSubjectivity(text):
  return TextBlob(text).sentiment.subjectivity

#Esta función devuelve la polaridad del tweet completo
#Polaridad: Se refiere a la medida del sentimiento mismo
#Los posibles valores van de -1 a 1
def getPolarity(text):
  return TextBlob(text).sentiment.polarity

#Clasificaremos según la polaridad, ya que es lo que nos interesa
#Si es menor a 0 es un tweet negativo
#Si es mayor a 0 es un tweet positivo
#Si es igual a 0 es un tweet neutro
def getClasification(text):
  if TextBlob(text).sentiment.polarity > 0:
    return 'Positive'
  elif TextBlob(text).sentiment.polarity == 0:
    return 'Neutral'
  else:
    return 'Negative'
```

Luego de eso, importamos nuestro dataset y haremos la siguiente serie de pasos para realizar una limpieza y tokenizacion

```python
data = pd.read_csv('covid_russia_vaccine_twits.csv')
tweets = pd.DataFrame(data['Tweet Text'])
#Agregamos los nuevos datos generados por las funciones creadas anteriormente
tweets['Polarity'] = tweets['Tweet Text'].apply(getPolarity)
tweets['Subjectivity'] = tweets['Tweet Text'].apply(getSubjectivity)
tweets['Clasify'] = tweets['Tweet Text'].apply(getClasification)
tweets['Label'] = tweets['Clasify'].map({'Positive': 1, 'Negative': 0, 'Neutral': 2})
```
Para el análisis de sentimientos consideramos a la clasificacion de tweets como Positivos y Negativos, es por ello que crearemos un nuevo dataframe con esos datos y se hará lo suguiente:

> Se hará limpieza de caracteres especiales <b>usando str.replace</b> y pasandole como parametros la expresión regular y el valor a cambiar (puede ser en viseversa)<br>
> Se aplicará una función lambda para eliminar palabras cortas o monosílabas <b>incluyendo stopwords</b> <br>
> Se aplicará una función lambda para tokenizar el tweet (separar un string en substrings)
<br>
> <i>NOTA: Una función lambda es una función X que se define sin nombre y que realizará ciertas acciones, normalmente se usa para aplicar una función a un dataframe</i>

```python
pos_neg_df = pd.DataFrame(tweets[tweets['Label'] != 2], columns=['Tweet Text', 'Label'])

# eliminando caracteres especiales, numeros, signos de puntuacion, etc
pos_neg_df['Clean Tweet'] = pos_neg_df['Tweet Text'].str.replace('[^a-zA-Z]+',' ')
# eliminando stopwords
pos_neg_df['Clean Tweet'] = pos_neg_df['Clean Tweet'].apply(lambda x: ' '.join([w.lower() for w in x.split() if len(w) > 2]))
# creando tokens o substrings
tokenized_message = pos_neg_df['Clean Tweet'].apply(lambda x: x.split())

from nltk.stem.porter import *
stemmer = PorterStemmer()
# aplicamos Porter Stemmer a cada uno de los strings
tokenized_message = tokenized_message.apply(lambda x: [stemmer.stem(i) for i in x])

# juntamos los tokens en un solo string
for i in range(len(tokenized_message)):
    tokenized_message.iloc[i] = ' '.join(tokenized_message.iloc[i])

pos_neg_df['Clean Tweet']  = tokenized_message
```

Una vez terminada las especificaciones para la limpieza de datos, aplicaremos ingeniería de características o Feature Engineering, que es un proceso donde se busca generar nuevas caracteristicas que pueden servir para el análisis de la data, en este caso hemos decidido generar las siguientes características:

> En análisis de sentimientos consideraremos las siguientes características adicionales:
> <b>Tamaño de la cadena</b>
> <b>Cantidad de palabras largas en la cadena</b>
> <b>Cantidad de palabras cortas en la cadena</b>
> Otra caracteristica también es la ponderación o porcentaje de sentimiento en el tweet dado por los signos de puntuación
> <b>Punctuation</b> hace referencia a dicha ponderación
> Otra caracteristica también es si algún tweet invoca a alguna pagina web, de tal manera que dicha web tenga alguna relación con el tema estudiado por el caso
> <b>Website</b> hace referencia a dicho descubrimiento

```python
pos_neg_df['Lenght'] = pos_neg_df['Tweet Text'].apply(lambda x : len(x) - x.count(" "))
pos_neg_df['Long Number'] = pos_neg_df['Tweet Text'].apply(lambda x : len(re.findall('\d{7,}',x)))
pos_neg_df['Short Number'] = pos_neg_df['Tweet Text'].apply(lambda x : len(re.findall('\d{4,6}',x)))

#De la libreria string, calculamos la ponderación de sentimiento agregado
#Esto se saca buscando en cada palabra del tweet, el count vendría a ser las veces de un simbolo encontrado en el texto
#Luego se lo promedia con la cantidad de palabras totales, excepto los whitespaces.
import string
def count_punct (text):
    count = sum([1 for x in text if x in string.punctuation])
    pp = round(100*count/(len(text)-text.count(" ")),3)
    return pp

#Aplicamos la función anterior al Tweet original (no al Tweet limpio)
pos_neg_df['Punctuation'] = pos_neg_df['Tweet Text'].apply(lambda x : count_punct(x))

#Creamos la función que analizará el tweet original (no el tweet limpio) y buscará algun indicio de que el mensaje incluye algun link
#Si es asi, con un booleano determinamos si es verdadero o falso, este dato lo usaremos para la parte de visualización y modelos
def website(text):
    if (len(re.findall('www|http|com|\.co',text))>0):
        return 1
    else:
        return 0

#Aplicamos la funcion web anterior a nuestro dataframe
pos_neg_df['WebSite'] = pos_neg_df['Tweet Text'].apply(lambda x : website(x))
#Guardamos los resultados en un nuevo dataset para el uso en la parte de visualizacion y modelos
pos_neg_df.to_csv('vacuna_dataset_preprocesado.csv', index=False)
```
### MODELOS :chart_with_downwards_trend:

#### MÁQUINAS DE VECTORES DE SOPORTE (SVM)
El Support Vector Classifier descrito en los apartados anteriores consigue buenos resultados cuando el límite de separación entre clases es aproximadamente lineal. Si no lo es, su capacidad decae drásticamente. Una estrategia para enfrentarse a escenarios en los que la separación de los grupos es de tipo no lineal consiste en expandir las dimensiones del espacio original.

El hecho de que los grupos no sean linealmente separables en el espacio original no significa que no lo sean en un espacio de mayores dimensiones. Las imágenes siguientes muestran como dos grupos, cuya separación en dos dimensiones no es lineal, sí lo es al añadir una tercera dimensión.

![svm](https://github.com/RQuilcatP10/M1-ProyectoFinal/blob/master/Otros/M1SVM.png)

<i><b><u> IMPLEMENTACIÓN EN R PARA ANÁLISIS DE SENTIMIENTOS</b></u></i>

Instalamos el paquete textmining de R para poder crear corpus (conjunto de textos) a partir de nuestro dataset ya preprocesado

```r
install.packages('tm')
library(tm)
```

Exportamos nuestro archivo .csv y leemos el contenido, luego de eso, realizamos una exploración a lo obtenido en la fase anterior

```r
tweets <- read.csv("vacuna_dataset_preprocesado.csv", sep=",")
#tenemos 1412 tweets positivos y 629 tweets negativos
table(tweets$Label)
```

Luego de ello creamos un corpus

```r
corpus = Corpus(VectorSource(tweets$Clean.Tweet))
```

Luego procedemos a vectorizar los datos y obtener frecuencias, luego de ello, eliminamos las palabras poco usadas, solo nos centraremos en las mas usadas, y a ese nuevo dataframe le agregamos el sentimiento que corresponde segun el archivo de origen.

```r
frequencies <- DocumentTermMatrix(corpus)

#Ahora solo trabajaremos con los terminos que mas se repiten
#Con esta funcion sacamos lo mas usado
sparse <- removeSparseTerms(frequencies, 0.995)

#Creamos un dataframe para trabajar con SVM
tweetsSparse <- as.data.frame(as.matrix(sparse))

#Asignamos a nuestro dataframe una columna con cada palabra
colnames(tweetsSparse) = make.names(colnames(tweetsSparse))

#Asignamos el valor de la clasificacion del tweet en una nueva columna
tweetsSparse$sentiment <- tweets$Label
```

Para realizar el SVM en R necesitaremos instalar las siguientes librerías

```r
install.packages('caTools')
install.packages('caret')
install.packages('e1071')
```
Luego crearemos a partir de nuestro data set, dos datasets, uno para test y otro para el entrenamiento del modelo, luego creamos un nuevo modelo, le pasaremos el factor dependiente, y la data de entrenamiento

```r
#Crearemos a partir de nuestro dataset, data para entrenamiento y data para test
#Asignamos un 80% de la data para entrenamiento y 20% para test
split <- sample.split(tweetsSparse$sentiment, SplitRatio =  0.8)

trainSparse = subset(tweetsSparse, split == TRUE)
testSparse = subset(tweetsSparse, split == FALSE)

#SVM recibe como primer parametro la variable dependiente (sentimiento)
#Como sentimiento es 0 o 1 R debe tratarlo como factor
#~. significa que trabajará con todas las variables
#El modelo trabajará con la data de entrenamiento
SVM <- svm(as.factor(sentiment)~., data = trainSparse)
```

Si todo sale correctamente, solo quedaría crear un objeto predictivo, pasarle el modelo entrenado, pasarle la data de test y crear una matriz de confusion para los resultados

```r
#Crearemos un objeto para la prediccion, el cual usaremos el train SVM y pasaremos como datos el test
predictsSVM <- predict(SVM, newdata = testSparse)
confusionMatrix(predictsSVM, as.factor(testSparse$sentiment))
```
Con ello tendremos implementado SVM para nuestro análisis de sentimientos, analizamos la matriz, segun los resultados y el Accuracy o precisión del modelo, el cual, si es alto y mayor a lo estimado (70% minimo) determinará si los nuevos tweets son negativos o positivos, y para el caso de estudio sería aprobatorio o desaprobatorioel nivel de aceptación de la vacuna.

#### K-MEANS (CLUSTERING)
K-means es un algoritmo de clasificación no supervisada (clusterización) que agrupa objetos en k grupos basándose en sus características. El agrupamiento se realiza minimizando la suma de distancias entre cada objeto y el centroide de su grupo o cluster. Se suele usar la distancia cuadrática.

El algoritmo consta de tres pasos:

1. Inicialización: una vez escogido el número de grupos, k, se establecen k centroides en el espacio de los datos, por ejemplo, escogiéndolos aleatoriamente.
2. Asignación objetos a los centroides: cada objeto de los datos es asignado a su centroide más cercano.
3. Actualización centroides: se actualiza la posición del centroide de cada grupo tomando como nuevo centroide la posición del promedio de los objetos pertenecientes a dicho grupo.
Se repiten los pasos 2 y 3 hasta que los centroides no se mueven, o se mueven por debajo de una distancia umbral en cada paso.

El algoritmo k-means resuelve un problema de optimización, siendo la función a optimizar (minimizar) la suma de las distancias cuadráticas de cada objeto al centroide de su cluster.

![CSV](https://github.com/RQuilcatP10/M1-ProyectoFinal/blob/master/Otros/M1KMeans.png)

<i><b><u> IMPLEMENTACIÓN EN R PARA ANÁLISIS DE SENTIMIENTOS</b></u></i>

Importamos el paquete de text mining para crear el corpus para el modelo, en este caso, la clasificacion sera apartir del texto del tweet, el cual será clasificado en los distintos grupos.

```r
library(tm)
tweets <- read.csv("vacuna_dataset_preprocesado.csv", sep=",")

#Construccion del corpus vectorizado
corpus <- Corpus(VectorSource(tweets$Clean.Tweet))

# Creamos el documenttermmatrix, nos quedamos con las palabras mas usadas (sparce)
tdm <- TermDocumentMatrix(corpus, 
                          control = list(minWordLength=c(1,Inf)))
t <- removeSparseTerms(tdm, sparse=0.98)
m <- as.matrix(t)

# Vemos las palabras mas frecuentes
freq <- rowSums(m)
freq <- subset(freq, freq>=50)
barplot(freq, las=2, col = rainbow(25))

# KMeans jerarquico, saca la distancia entre cada elemento o palabra en un tweet,
# Luego se le aplica hclust (clustering jerarquico) y vemos el agrupamiento de palabras para K grupos
distance <- dist(scale(m))
print(distance, digits = 2)
hc <- hclust(distance, method = "ward.D")
plot(hc, hang=-1)
rect.hclust(hc, k=12)

#k-means simple para cada palabra en un tweet.
m1 <- t(m)
k <- 3
kc <- kmeans(m1, k)
kc
```

Como se ve en el codigo, el modelo recive el texto del tweet, pero este primero ha ido cambiando su estructura, pasando a ser un corpus, para vectorizar cada palabra, luego se transformo en un TermDocumentMatrix, el cual tiene como columnas las palabras y como filas cada tweet text.

Luego de ello, creamos una matriz apartir de la matrizdocument donde se ha omitido palabras que son poco mencionadas, finalmente vemos dos tipos de clustering, uno jerarquico para ver el grado de familiaridad entre una palabra y la otra. Mientras que si aplicamos un kmeans simple, obtendremos una matriz con cada palabra asignada a uno de los grupos definidos, por cada K grupo, el Accuracy del modelo irá variando, mientras mayor el accuracy, mayor es la probabilidad de predecir si un tweet es aprobatorio (positivo) o desaprobatorio (negativo).
