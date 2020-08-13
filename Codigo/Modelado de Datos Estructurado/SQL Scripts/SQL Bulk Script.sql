create table UsuariosCsv(
	ScreenName varchar(100),
	FullName varchar(100)
)
BULK INSERT UsuariosCsv
FROM 'pathFile'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)
Insert into Usuarios(ScreenName,FullName) SELECT ScreenName,FullName from UsuariosCsv
drop table UsuariosCsv
--select * from Usuarios
/*******************************************************/
create table Usuarios_DetalleCsv(
	ScreenName VARCHAR(100), 
	Followers INT, 
	Follows INT, 
	UserSince DATE, 
	Location VARCHAR(200), 
	Bio VARCHAR(MAX)
)
BULK INSERT Usuarios_DetalleCsv
FROM 'pathFile'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)
Insert into Usuarios_Detalle(ScreenName, Followers,Follows,UserSince,Location,Bio) SELECT ScreenName, Followers,Follows,UserSince,Location,Bio from Usuarios_DetalleCsv
drop table Usuarios_DetalleCsv
/*******************************************************/
create table TweetsCsv(
	Date_Tweet DATETIME, 
	TweetText VARCHAR(MAX), 
	TweetID BIGINT, 
	ScreenName varchar(100)
)
BULK INSERT TweetsCsv
FROM 'pathFile'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)
Insert into Tweets(Date_Tweet,TweetText,TweetID,ScreenName) SELECT Date_Tweet,TweetText,TweetID,ScreenName from TweetsCsv
drop table TweetsCsv
--select * from TweetsCsv
/************************************************************/
create table Tweets_DetalleCsv(
	TweetID BIGINT,
	Retweets INT, 
	Favorites INT, 
	App VARCHAR(100)
)
BULK INSERT Tweets_DetalleCsv
FROM 'pathFile'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)
Insert into Tweets_Detalle(TweetID,Retweets,Favorites,App) SELECT TweetID,Retweets,Favorites,App from Tweets_DetalleCsv
drop table Tweets_DetalleCsv

