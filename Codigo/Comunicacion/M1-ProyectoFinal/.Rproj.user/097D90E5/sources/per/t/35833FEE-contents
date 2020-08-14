#install.packages('tm')
#install.packages('caTools')
#install.packages('caret')
#install.packages('e1071')
library(caret)
library(caTools)
library(e1071)
library(plyr)
library(tm)

SVMout <- {
  tweets <- read.csv("www/datos/Csv/vacuna_dataset_preprocesado.csv", sep=",")
  #tenemos 1412 tweets positivos y 629 tweets negativos
  #table(tweets$Label)
  #Creamos un corpus a partir del texto preprocesado
  corpus = Corpus(VectorSource(tweets$Clean.Tweet))
  #length(corpus)
  #content(corpus[[20]])
  frequencies <- DocumentTermMatrix(corpus)
  #Tiene 2041 tweets (filas)
  #Tiene 6976 terminos (columnas)
  #la palabra mas larga tiene 31 caracteres
  #frequencies
  
  #inspect(frequencies[800:805, 505:515])
  #findFreqTerms(frequencies, lowfreq = 50)
  #Ahora solo trabajaremos con los terminos que mas se repiten
  #Con esta funcion sacamos lo mas usado
  sparse <- removeSparseTerms(frequencies, 0.995)
  #sparse
  #Creamos un dataframe para trabajar con SVM
  tweetsSparse <- as.data.frame(as.matrix(sparse))
  
  #Asignamos a nuestro dataframe una columna con cada palabra
  colnames(tweetsSparse) = make.names(colnames(tweetsSparse))
  
  #Asignamos el valor de la clasificacion del tweet en una nueva columna
  tweetsSparse$sentiment <- tweets$Label
  
  #Seteamos el valor raiz en R para valores replicables
  set.seed(12)
  #Crearemos a partir de nuestro dataset, data para entrenamiento y data para test
  #Asignamos un 80% de la data para entrenamiento y 20% para test
  split <- sample.split(tweetsSparse$sentiment, SplitRatio =  0.8)
  
  trainSparse = subset(tweetsSparse, split == TRUE)
  testSparse = subset(tweetsSparse, split == FALSE)
  #282 tweets son positivos en test
  #126 tweets son negativos en test
  #El modelo solo clasificará positivos
  #table(test$sentiment)
  #SVM recibe como primer parametro la variable dependiente (sentimiento)
  #Como sentimiento es 0 o 1 R debe tratarlo como factor
  #~. significa que trabajará con todas las variables
  #El modelo trabajará con la data de entrenamiento
  SVM <- svm(as.factor(sentiment)~., data = trainSparse)
  #summary(SVM)
  #Crearemos un objeto para la prediccion, el cual usaremos el train SVM y pasaremos como datos el test
  predictsSVM <- predict(SVM, newdata = testSparse)
  
  confusionMatrix(predictsSVM, as.factor(testSparse$sentiment))
  
}
