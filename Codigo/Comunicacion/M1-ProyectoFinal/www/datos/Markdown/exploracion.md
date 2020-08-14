### CONSULTAS EXPLORATORIAS A LOS DATOS 

En esta fase veremos a través de distintos scripts la data almacenada en nuestra base de datos anteriormente creada, para ello tenemos 2 sencillos pasos de realizar.
Por un lado tenemos los siguientes scripts seleccionados por nosotros:

```sql
--1. Consulta exploratoria a Tweets
	SELECT TOP 10 * FROM Tweets 
--2. Consulta exploratoria a Usuarios
	SELECT * FROM Usuarios
--3. Consulta exploratoria al detalle de usuario
	SELECT TOP 10 * FROM Usuarios_Detalle
--4. Consulta exploratoria al detalle de tweets
	SELECT TOP 10 * FROM Tweets_Detalle
--5. Seleccionar el detalle de un Usuario especifico
	SELECT * FROM Usuarios_Detalle WHERE ScreenName = '@adaptiveoptics'
--6. Seleccionar los tweets pertenecientes a un Usuario especifico
	SELECT * FROM Tweets WHERE ScreenName = '@adaptiveoptics'
--7. Ordenar Usuarios por fecha de creación
	SELECT FullName FROM Usuarios ORDER BY FullName ASC
--8. Ordenar Usuarios por nombres que empiecen con la letra 'A'
	SELECT Fullname FROM Usuarios WHERE FullName LIKE '[A]%' ORDER BY FullName ASC
--9. Exploración de cuantos usuarios tienen una cuenta sin una locación asociada
	SELECT COUNT(*) as SinLocation FROM Usuarios_Detalle WHERE Location IS NULL
--10. Seleccion de Usuario con mayor Numero de seguidores
	SELECT * FROM Usuarios_Detalle WHERE Followers = (SELECT MAX(Followers) FROM Usuarios_Detalle)
--11. Seleccion de Usuarios con menor Numero de seguidores
	SELECT * FROM Usuarios_Detalle WHERE Followers = (SELECT MIN(Followers) FROM Usuarios_Detalle)
--12. Seleccion de la info completa de un tweet
	SELECT * FROM Tweets t INNER JOIN Tweets_Detalle td on td.TweetID = t.TweetID
--13. Seleccion de los usuarios mas antiguos
	SELECT TOP 1 u.FullName, u.ScreenName, ud.UserSince, ud.Location FROM Usuarios u INNER JOIN Usuarios_Detalle ud ON u.ScreenName = ud.ScreenName ORDER BY UserSince ASC
--14. Seleccion del usuario mas reciente
	SELECT TOP 1 u.FullName, u.ScreenName, ud.UserSince, ud.Location FROM Usuarios u INNER JOIN Usuarios_Detalle ud ON u.ScreenName = ud.ScreenName ORDER BY UserSince DESC
--15. Seleccion del total de plataformas mas utilizada para twitear
	SELECT App, COUNT(App) as Total FROM Tweets_Detalle GROUP BY App ORDER BY Total DESC
--16. Seleccion del top 1 de plataforma mas usada
	SELECT TOP 1 App, COUNT(App) as Total FROM Tweets_Detalle GROUP BY App ORDER BY Total DESC
--17. Seleccion del top 1 de plataforma menos usada
	SELECT TOP 1 App, COUNT(App) as Total FROM Tweets_Detalle GROUP BY App ORDER BY Total ASC
--18. Seleccion del Tweet con mas retweets
	SELECT t.TweetText, t.Date_Tweet FROM Tweets_Detalle td INNER JOIN Tweets t on t.TweetID = td.TweetID WHERE Retweets = (SELECT MAX(Retweets) FROM Tweets_Detalle)
--19. Seleccion de los tweets entre los dias lunes 10 y martes 11
	SELECT TweetText FROM Tweets WHERE Date_Tweet BETWEEN '08-10-2020' AND '08-12-2020'
```

Y por otro lado tenemos en Python una conexion a PYODBC, instalada en la fase anterior, y para cada una de las consultas listadas solo es necesario seguir el siguiente formato:

```python
cons_nro = pd.read_sql_query("SCRIPT PERTENECIENTE AL NRO", conn)
cons_nro
```