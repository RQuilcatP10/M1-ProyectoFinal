#### A) MODELADO DE LA BASE DE DATOS
Según el dataset que usaremos, modelaremos la base de datos para albergar la información recolectada en el archivo .csv, para ellos analizaremos los campos que este contiene, y con ello procedemos a identificar:

1. Se pueden crear 2 tablas a partir del dataset los cuales son:
    * <b><u>USUARIO</u></b> : Hace referencia al usuario de twitter, aqui se puede guardar el usuario, nombre real del usuario, número de personas a que sigue, número de personas que le siguen, fecha de creación, locación (sin ubigeo completo), y una descripción.
    * <b><u>TWEETS</u></b> : Hace referencia al tweet que realiza un determinado usuario, este contendrá el usuario que lo creo, la fecha de publicación, el ID del tweet, el tweet textual, nro de retweets, favoritos, dispositivo desde el que se realizo.


2. El modelo se ve muy simple a primera vista, por lo que se le aplico normalización, de tal manera de crear una estructura basada en master-detail, entonces cada tabla se dividirá en 2, una tabla maestra con su respectivo detalle quedando de la siguiente manera:
    * <b><u>USUARIO</u></b> :Hace referencia al usuario de Twitter, solo se guardará el userID y el nombre real del usuario.
    * <b><u>USUARIO_DETALLE</u></b> : Aquí se guardarán la cantidad de followers, las personas a las que sigue, fecha de creación, locación, biografía. El objetivo de la tabla es servir como un log de cambios de estados del usuario, por el momento solo guardaremos la información brindada por el dataset.
    * <b><u>TWEET</u></b> :Hace referencia al tweet que publica un determinado usuario, se guardará dicho usuario, el texto del tweet, fecha de creación, el IDTweet.
    * <b><u>TWEET_DETALLE</u></b> : Hace referencia a los detalles del tweet, se guardarán los retweets (a futuro se podría guardar el usuario que retweeteo), quienes dieron favorito (a futuro se podría guardar el usuario que dio like), la aplicación desde donde se realizó el Twitter.

#### B) IMPLEMENTACIÓN DE LA BASE DE DATOS
En esta parte, para el proyecto hemos hecho las siguientes consideraciones:
>   1. Se hará uso de una base de datos alojada en SQL Server, creada con un servicio en Amazon Web Services.
>   2. Se hará uso del dataset para dividirlo y formar archivos .csv para insertarlos a través de la función BULK de SQL.
>   3. Al no contar con un servidor de alojamiento de base de datos fisico, primero crearemos la base de datos de manera local y también en el servidor creado, esto con el fin de crear un script que crea el esquema, las tablas, y los registros, y lo ejecutaremos usando Python.


#### Teniendo en cuenta esta estructura, el modelo quedará de la siguiente manera:
