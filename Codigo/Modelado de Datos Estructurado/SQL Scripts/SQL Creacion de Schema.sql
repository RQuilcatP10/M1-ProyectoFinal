create table Usuarios(
	ScreenName varchar(100) NOT NULL PRIMARY KEY,
	FullName varchar(100)
)

create table Usuarios_Detalle(
	ScreenName VARCHAR(100) FOREIGN KEY REFERENCES Usuarios(ScreenName), 
	Followers INT, 
	Follows INT, 
	UserSince DATE, 
	Location VARCHAR(200), 
	Bio VARCHAR(MAX)
)

create table Tweets (
	Date_Tweet DATE, 
	TweetText VARCHAR(MAX), 
	TweetID BIGINT NOT NULL PRIMARY KEY, 
	ScreenName varchar(100) FOREIGN KEY REFERENCES Usuarios(ScreenName)
)

create table Tweets_Detalle(
	TweetID BIGINT FOREIGN KEY REFERENCES Tweets(TweetID),
	Retweets INT, 
	Favorites INT, 
	App VARCHAR(100)
)