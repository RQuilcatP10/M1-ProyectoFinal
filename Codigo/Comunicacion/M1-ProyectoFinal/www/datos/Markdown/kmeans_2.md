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
