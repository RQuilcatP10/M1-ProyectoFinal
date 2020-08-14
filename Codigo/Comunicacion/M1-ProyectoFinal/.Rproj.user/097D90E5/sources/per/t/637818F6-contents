library(e1071)
library(tidyverse)
library(tidytext)
library(naivebayes)
#library(tm)
#library(caret)

Bayesout <- {
  tuits_df <- read.csv(file = 'www/datos/Csv/tweets_mx.csv', stringsAsFactors = F, fileEncoding = "latin1")
  #%>%
  #  tbl_df
  #View(tuits_df)
  
  quitar_url <- function(texto) {
    gsub("\\<http\\S*\\>|[0-9]", " ", texto)
  }
  
  tuits_df %>%
    unnest_tokens(input = "text", output = "palabra") %>%
    count(screen_name, status_id, palabra) %>%
    spread(key = palabra, value = n)
  
  crear_matriz <- function(tabla) {
    tabla %>%
      mutate(text = quitar_url(text)) %>%
      unnest_tokens(input = "text", output = "palabra") %>%
      count(screen_name, status_id, palabra) %>%
      spread(key = palabra, value = n) %>%
      select(-status_id)
  }
  
  ejemplo_matriz <-
    tuits_df %>%
    mutate(screen_name = ifelse(screen_name == "MSFTMexico", screen_name, "Otro"),
           screen_name = as.factor(screen_name)) %>%
    crear_matriz
  
  set.seed(2001)
  ejemplo_entrenamiento <- sample_frac(ejemplo_matriz, .7)
  ejemplo_prueba <- setdiff(ejemplo_matriz, ejemplo_entrenamiento)
  
  
  ejemplo_modelo <- naive_bayes(formula = screen_name ~ .,  data = ejemplo_entrenamiento)
  
  ejemplo_prediccion <- predict(ejemplo_modelo, ejemplo_prueba)
  
  #head(ejemplo_prediccion, 25)
  
  confusionMatrix(ejemplo_prediccion, ejemplo_prueba[["screen_name"]]) 
}
