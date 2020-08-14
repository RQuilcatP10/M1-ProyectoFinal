library(tm)
library(caret)
library(caTools)
library(rpart)
library(rpart.plot)

CART2total <- {
  tweets <- read.csv("www/datos/Csv/vacuna_dataset_preprocesado.csv", sep=",")
  
  tweets$Negative <- as.factor(tweets$Label == 0)
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
  
  predictCART <- predict(tweet.CART, testSparse, type='class')
  
  
  control <- trainControl(method='cv', number=10)
  metric <- 'Accuracy'
  
  # CART
  set.seed(101)
  tweet.cart <- train(Negative~., data=trainSparse, method='rpart',
                      trControl=control, metric=metric)
  
  tweet.pred <- predict(tweet.cart, testSparse)
  
  # Create Confusion Matrix
  confusionMatrix(tweet.pred, testSparse$Negative)
}

