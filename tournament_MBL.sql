
--disconnect from any connected db
\c vagrant

--delete DB and/or table(s) if already exists without an exception
DROP DATABASE IF EXISTS tournament;

--create tournament database
CREATE DATABASE tournament;
\c tournament

--delete DB and/or table(s) if already exists without an exception
DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS matches;

--create tables
CREATE TABLE players(ID SERIAL PRIMARY KEY, name VARCHAR(20));
CREATE TABLE matches(
	ID SERIAL PRIMARY KEY,
	winner int references Players(id),
	loser int references Players(id));

--matches: the number of matches the player has played
CREATE VIEW matches_view AS
	SELECT players.id, players.name, matches.id,
	COUNT(matches.id) as matches_played
	FROM players, matches
	--LEFT JOIN (SELECT * FROM matches WHERE winner > 0) as n
	ON players.id = matches.id
	GROUP BY players.id;

--wins: the number of matches the player has won
CREATE VIEW wins AS
	SELECT players.id, COUNT(matches.winner) as match_list_winner
	FROM players
	LEFT JOIN matches
	ON players.id = matches.winner
	GROUP BY players.id;

--player standings: list of players and their win records
CREATE VIEW standings AS
	SELECT players.id, players.name,
	coalesce((SELECT COUNT(matches.winner) FROM players, matches
	GROUP BY players.id),0) as win_record,
	coalesce((SELECT COUNT(matches.winner) +
	COUNT(matches.loser)FROM matches
	GROUP BY players.id),0) as matches
	FROM players
	LEFT JOIN matches
	ON players.id = matches.winner
	ORDER BY win_record DESC;
	--ORDER BY win_record DESC;
	--FROM Players, count, wins
	--WHERE players.id = wins.id AND wins.id = count.id;

	/*--player standings: list of players and their win records
CREATE VIEW standings AS
	SELECT player.id, winner, loser, count(matches.winner) as win_record
	FROM players
	LEFT JOIN matches
	ON players.id = matches.winner
	GROUP BY win_record;*/

/*--player standings: list of players and their win records
CREATE VIEW standings AS
	SELECT players.id, count(matches.winner) as win_record
	FROM players left join matches
	ON players.id = matches.winner
	GROUP BY players.id
	ORDER BY win_record DESC;
*/

--standings of result for each match player
/*CREATE VIEW EMP AS
	SELECT players.id, sum(standings.wins) as n
	FROM players, standings, matches
	WHERE players.id = matches.id
	AND matches.id = standings.id
	GROUP BY players.id;
*/
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.


