# Análisis de Sentimientos en los tweets acerca de la vacuna rusa contra el COVID-19

_Universidad Privada Antenor Orrego_
<br>
_Facultad de Ingeniería_
<br>
_Escuela Profesional de Ingeniería de Computación y Sistemas_
<br>
_Proyecto desarrollado para el curso de Administración y Arquitectura de Mainframes_

## Autores
| <a href="https://github.com/RQuilcatP10" target="_blank">**Rodrigo Quilcat Pesantes**</a>  | <a href="https://github.com/Eddifog" target="_blank">**Diego Liberato Bernal**</a> |
| :---: |:---:|
| [![Rodrigo](https://github.com/RQuilcatP10.png?size=200)](https://github.com/RQuilcatP10.png?size=50) | [![Diego](https://github.com/eddifog.png?size=200)](http://fvcproductions.com)  |
| <a href="http://github.com/RQuilcatP10" target="_blank">`github.com/RQuilcatP10`</a> | <a href="http://github.com/Eddifog" target="_blank">`github.com/Eddifog`</a> |

## GENERALIDADES
El trabajo final es un producto software que desarrolla el ciclo de vida de un proyecto de ciencia de datos, para el cual, el equipo desarrollador seleccionó el tema de "Análisis de Sentimientos" para demostrar dicho ciclo de vida.
Se usará la herramienta cloud Google Colab el cual soporta y se basa en los Notebooks de Jupyter, que permite el uso gratuito de GPUs y TPUs, todo bajo el lenguaje Python en su versión 2.7 y 3.6
#### CASO DE ESTUDIO: VACUNA CONTRA EL COVID :microscope:
<p style='text-align: justify;'> El mundo actualmente vive una crisis sanitaria a causa del virus SARS-Cov-2 o más conocido como coronavirus (COVID-19) el cual ha puesto en una situación dificil a casi la totalidad de países, cuyo objetivo desde el inicio de esta pandemia fue hallar la vacuna para contrarrestar dicho virus. Actualmente en el mes de agosto aproximadamente van una totalidad de 20,2 millones de casos de contagio y más de 741.000 muertos en todo el mundo. De manera local, en Perú vamos un aproximado de 483 mil casos de contagio, y 21.000 fallecidos. <br> El día 11 de Agosto del 2020, el presidente de la Federación Rusa, Vladímir Putin, declaro a la prensa mundial que Rusia ya tiene una vacuna aprobada y registrada contra el coronavirus, el cual fue desarrollado por el Instituto Gamaleya y fue registrada después de dos meses de ensayos en humanos. Dado el caso, en redes sociales, a nivel mundial, se vino criticando o aplaudiendo dicho logro por parte de Rusia y su presidente. A demás declaran que por una parte es poco confiable, hay muchas dudas y descubrimientos por hacer, mientras que muchos países en el mundo estan decididos a comprarle a Rusia dichas vacunas en el menor tiempo posible, ya que actualmente se están produciendo en masa.<br> Como analistas de datos, queremos determinar que tan confiable puede ser esta vacuna, y cuantos prefieren no opinar o estar en contra de dicha vacuna, para ello nos basaremos en los comentarios que se realicen dentro de la red social Twitter, la cual es una gran fuente de datos para poder extraer dicha información, y a su vez, nos permitirá hacer una exploración del ciclo de vida de un proyecto de ciencia de datos.</p>

#### ANÁLISIS DE SENTIMIENTOS :fearful: :smile: :anguished: :rage:
<p style='text-align: justify;'> El Análisis de Sentimientos es un área de investigación enmarcada dentro del campo del Procesamiento del Lenguaje Natural y cuyo objetivo fundamental es el tratamiento computacional de opiniones, sentimientos y subjetividad en textos. En este contexto, una opinión es una valoración positiva o negativa acerca de un producto, servicio, organización, persona o cualquier otro tipo de ente sobre la que se expresa un texto determinado.</p>

#### PROCESAMIENTO DE LENGUAJE NATURAL :speech_balloon:
<p style='text-align: justify;'>El procesamiento del lenguaje natural, abreviado PLN​​ —en inglés natural language processing, NLP— es un campo de las ciencias de la computación, inteligencia artificial y lingüística que estudia las interacciones entre las computadoras y el lenguaje humano.</p>

## CONCLUSIONES 

1. El ciclo de vida de un proyecto de ciencias de datos nos permite explorar muchas formas de ver y analizar la informacion que tenemos a la mano, desde informacion publica, hasta información privada, etc.
2. El analisis de sentimientos refleja mucho las expresiones reales del usuario que realiza la publicacion de ciertos textos en la internet, normalmente en redes sociales. Como temas relevantes como la vacuna del COVID-19 creada en Rusia, generó dos grupos, donde la mitad abogaba por dicha vacuna, como un milagro y la aprobaban, mientras que otro grupo no, entonces se podría decir que la opinion publica puede impactar en el gobierno de un país, ya que ellos serán los principales en adquirir dicha vacuna.
3. Los modelos predictivos nos permiten automatizar muchas tareas, entre ellas clasificar elementos cotidianos, etc. En nuestro caso de estudio determinamos que de los 4 modelos explorados, y con la data que hemos recolectado, la máquina de vectores de soporte es la mas confiable por la precisión mas alta que ha devuelto el modelo. Pero sabemos que a más data, mejor será el modelo, será cuestión de volver a entrenar los 4 modelos y obtener nuevos resultados.
4. Según lo analizado por los modelos y por el mismo proceso de análisis de sentimientos, la mayoría de la población mundial en redes sociales, aprueba que la vacuna sea exportada y usada.
