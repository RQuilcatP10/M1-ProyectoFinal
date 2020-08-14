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
#### El resultado que obtendremos es el siguiente:

