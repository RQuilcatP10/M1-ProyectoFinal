Los pasos para realizar la partición del espacio son:

1. Dado un conjunto de covariables (características), encontrar la covariable que permita predecir mejor la variable respuesta.
2. Encontrar el punto de corte sobre esa covariable que permita predecir mejor la variable respuesta.
3. Repetir los pasos anteriores hasta que se alcance el criterio de parada.

Algunas de las ventajas de los árboles de regresión son:

* Fácil de entender e intrepretar.
* Requiere poca preparación de los datos.
* Las covariables pueden ser cualitativas o cuantitativas.
* No exige supuestos distribucionale

<i><b><u> IMPLEMENTACIÓN EN R PARA ANÁLISIS DE SENTIMIENTOS</b></u></i>

Al igual que los demas algoritmos está basado en el análisis de corpus creados a partir de textos, en este caso tweets, para ello seguiremos la misma metodología de los anteriores modelos, haremos un split a la data, para tener data para test y para el entrenamiento, entrenaremos el modelo y luego crearemos una matriz de confusion para corroborar valores

```r
library(tm)
tweets <- read.csv("www/datos/Csv/vacuna_dataset_preprocesado.csv", sep=",")

tweets$Negative <- as.factor(tweets$Label == 0)
# Look at the number and proportion of negative tweets
table(tweets$Negative)

tweet_corpus <- Corpus(VectorSource(tweets$Tweet))

#tweet_corpus
clean_corpus <- function(corp){
  corp <- tm_map(corp, content_transformer(tolower))
  corp <- tm_map(corp, removePunctuation)
  corp <- tm_map(corp, removeWords, stopwords('en'))
  corp <- tm_map(corp, stemDocument)
}

clean_corp <- clean_corpus(tweet_corpus)
frequencies <- TermDocumentMatrix(clean_corp)

#findFreqTerms(frequencies, lowfreq = 20)

dtm <- DocumentTermMatrix(clean_corp)
sparseData <- removeSparseTerms(dtm, sparse=0.995)
sparsedf <- as.data.frame(as.matrix(sparseData))
colnames(sparsedf) <- make.names(colnames(sparsedf))
sparsedf$Negative <- tweets$Negative

set.seed(101)
split <- sample.split(sparsedf$Negative, SplitRatio = 0.7)
trainSparse <- subset(sparsedf, split==TRUE)
testSparse <- subset(sparsedf, split==FALSE)

tweet.CART <- rpart(Negative~., trainSparse, method='class')
#show plot
#prp(tweet.CART)
library(caret)
predictCART <- predict(tweet.CART, testSparse, type='class')

# Compute Accuracy
#table(predictCART, testSparse$Negative)
#postResample(predictCART, testSparse$Negative)

control <- trainControl(method='cv', number=10)
metric <- 'Accuracy'

# CART
set.seed(101)
tweet.cart <- train(Negative~., data=trainSparse, method='rpart',
                    trControl=control, metric=metric)

tweet.pred <- predict(tweet.cart, testSparse)

# Create Confusion Matrix
confusionMatrix(tweet.pred, testSparse$Negative)
```
Como resultados obtuvimos un 79% de precision en el modelo, por lo que es confiable saber si un tweet es aprobatorio o no para nuestro caso
