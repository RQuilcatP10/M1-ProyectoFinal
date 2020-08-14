Donde:

1. P(h): es la probabilidad de que la hipótesis h sea cierta (independientemente de los datos). Esto se conoce como la probabilidad previa de h.

2. P(D): probabilidad de los datos (independientemente de la hipótesis). Esto se conoce como probabilidad previa.

3. P(h|D): es la probabilidad de la hipótesis h dada los datos D. Esto se conoce como la probabilidad posterior.

4. P(D|h): es la probabilidad de los datos d dado que la hipótesis h era cierta. Esto se conoce como probabilidad posterior.

En caso de que se tenga una sola característica, el clasificador Naive Bayes calcula la probabilidad de un evento en los siguientes pasos:

* Paso 1: calcular la probabilidad previa para las etiquetas de clase dadas.

* Paso 2: determinar la probabilidad de probabilidad con cada atributo para cada clase.

* Paso 3: poner estos valores en el teorema de Bayes y calcular la probabilidad posterior.

<i><b><u> IMPLEMENTACIÓN EN R PARA ANÁLISIS DE SENTIMIENTOS</b></u></i>

Para implementar el modelo Naive Bayes en R necesitamos instalar algunos paquetes

```r
install.packages('tidyverse')
install.packages('tidyverse')
install.packages('naivebayes')
install.packages('e1071')
```

Para este caso haremos uso de un subdataset, primero le realizaremos exploración y limpieza a estos datos
>Se le indica como fileEncoding el tipo *latin1* para que pueda soportar los caracteres propios del español

```r
tweets_df <- read.csv(file = 'tweets_mx.csv', stringsAsFactors = F, fileEncoding = "latin1")
```

Usaremos gsub para que con el uso de expresiones regulares podamos quitar los links que se puedan encontrar dentro de los tweets

```r
quitar_url <- function(texto) {
    gsub("\\<http\\S*\\>|[0-9]", " ", texto)
}
```

Convertiremos nuestros datos en una matriz dispersa, por lo que tendremos que segmentar cada palabra en columnas, hacer cuenta de la aparición de cada palabra y se le dara un formato ancho

```r
tweets_df %>%
  unnest_tokens(input = "text", output = "palabra") %>%
  count(screen_name, status_id, palabra) %>%
  spread(key = palabra, value = n)
```

Al ser un proceso repetitivo lo hacemos función y aplicamos el filtro para quitar links y de paso eliminamos columnas innecesarias

```r
crear_matriz <- function(tabla) {
  tabla %>%
    mutate(text = quitar_url(text)) %>%
    unnest_tokens(input = "text", output = "palabra") %>%
    count(screen_name, status_id, palabra) %>%
    spread(key = palabra, value = n) %>%
    select(-status_id)
}
```
<b> Naive Bayes en R </b>

Lo que se busca es poder predecir si un tweet le pertenece a un usuario en particular, solo se usarán 2 categorías, en caso de no pertenecer, simplemente se le pone "Otro"

```r
ejemplo_matriz <-
  tweets_df %>%
  mutate(screen_name = ifelse(screen_name == "MSFTMexico", screen_name, "Otro"),
         screen_name = as.factor(screen_name)) %>%
  crear_matriz
```
Se van a dividir los datos de modo que tengamos 70% de ellos en el set de entrenamiento y el resto en el set de prueba. 
>Se usa seed para que sea reproducible y lo colocamos antes de obtener el primer set

```r
set.seed(2001)
ejemplo_entrenamiento <- sample_frac(ejemplo_matriz, .7)
ejemplo_prueba <- setdiff(ejemplo_matriz, ejemplo_entrenamiento)
```

Llamamos a la función naive_bayes y le pasamos la variable objetivo para clasificar y los datos que serán usados

```r
ejemplo_modelo <- naive_bayes(formula = screen_name ~ .,  data = ejemplo_entrenamiento)
```

Para realizar predicciones usaremos la funcion *predict* y le pasamos el modelo y datos nuevos, por lo que le pasaremos el set de prueba

```r
ejemplo_prediccion <- predict(ejemplo_modelo, ejemplo_prueba)
```
Para analizar el éxito del modelo, crearemos una matriz de confusión, le pasamos el vector con las predicciones y los valores reales de screen_name

```r
confusionMatrix(ejemplo_prediccion, ejemplo_prueba[["screen_name"]])
```
>Obtuvimos una precisión del 92.01%, por lo que no se realizó algún ajuste en el modelo. También se obtuvo 93.92% de Especificidad, que corresponde en este caso a la categoria "Otro"