### PREPARACIÓN DE LOS DATOS

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

> Otra caracteristica también es la ponderación o porcentaje de sentimiento en el tweet dado por los signos de puntuación <b>Punctuation</b> hace referencia a dicha ponderación

> Otra caracteristica también es si algún tweet invoca a alguna pagina web, de tal manera que dicha web tenga alguna relación con el tema estudiado por el caso <b>Website</b> hace referencia a dicho descubrimiento

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