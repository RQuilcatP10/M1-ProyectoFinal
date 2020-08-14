
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
Con ello tendremos implementado SVM para nuestro análisis de sentimientos, analizamos la matriz, segun los resultados y el Accuracy o precisión del modelo.