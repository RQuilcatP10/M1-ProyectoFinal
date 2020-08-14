library(tm)
Kmeans_m1_out <-{
  tweets <- read.csv("www/datos/Csv/vacuna_dataset_preprocesado.csv", sep=",")
  
  #Construccion del corpus vectorizado
  corpus <- Corpus(VectorSource(tweets$Clean.Tweet))
  
  # Creamos el documenttermmatrix, no quedamos con las palabras mas usadas (sparce)
  tdm <- TermDocumentMatrix(corpus, 
                            control = list(minWordLength=c(1,Inf)))
  t <- removeSparseTerms(tdm, sparse=0.98)
  m <- as.matrix(t)
  
  # Vemos las palabras mas frecuentes
  freq <- rowSums(m)
  freq <- subset(freq, freq>=50)
  #barplot(freq, las=2, col = rainbow(25))
  
  # KMeans jerarquico, saca la distancia entre cada elemento o palabra en un tweet,
  # Luego se le aplica hclust (clustering jerarquico) y vemos el agrupamiento de palabras para K grupos
  distance <- dist(scale(m))
  #print(distance, digits = 2)
  hc <- hclust(distance, method = "ward.D")
  #plot(hc, hang=-1)
  #rect.hclust(hc, k=12)
  
  # No jerarquico k-means clustering para cada palabra en un tweet.
  set.seed(222)
  m1 <- t(m)
}
