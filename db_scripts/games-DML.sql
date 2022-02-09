// -- Add a new game
	INSERT INTO game(title, minplayers, maxplayers, minage, playtime, rating, timesplayed, bggid, publisher, year)
	VALUES (:title, :minplayers, :maxplayers, :minage, :playtime, :rating, :timesplayed, :bggid, :publisherid, :year),
		//get new ID returned from INSERT
		// assign to var :gameID
		
	INSERT INTO designer (id, firstname, lastname, country)
	VALUES (1, 'Alan', 'Moon', 'USA'),
		//get new ID returned from INSERT
		// assign to var :designerID

	INSERT INTO publisher (id, name, city, state, country)
	VALUES (1, 'Days of Wonder', '', '', ''),
		//get new ID returned from INSERT
		// assign to var :publisherID

	INSERT INTO mechanic (id, mechanic)
	VALUES (1, 'Card Drafting'),
		//get new ID returned from INSERT
		// assign to var :mechanicID

	INSERT INTO gamedesigner (gameid, designerid)  VALUES(:gameID, :designerID);

	INSERT INTO gamemechanic (gameid, mechanicid) VALUES(:gameID, :mechanicID);

// -- Add a new game video
	INSERT INTO video (title, url, type) VALUES (:title, :url, :type);
		//get new ID returned from INSERT
		// assign to var :videoID

	INSERT INTO gamevideo (gameid, videoid) VALUES (:gameID, :videoID);
	
//-- Delete from tables
	DELETE FROM game WHERE id = :gameID;
	DELETE FROM designer WHERE id = :designerID;
	DELETE FROM mechanic WHERE id = :mechanicID;
	DELETE FROM publisher WHERE id = :publisherID;
	DELETE FROM video WHERE id = :videoID;
	DELETE FROM gamedesigner WHERE gameid = :gameID AND designerid = :designerID;
	DELETE FROM gamemechanic WHERE gameid = :gameID AND mechanicid = :mechanicID;
	DELETE FROM gamevideo WHERE gameid = :gameID AND videoid = :videoID;
	DELETE FROM gamephoto WHERE id = :photoID;

//-- Edit a publisher
	SELECT * from publisher ORDER BY  name;

	UPDATE publisher SET name = :name, city = :state, state = :state, country = :country WHERE ID = :publisherID;

//-- Edit a designer
	SELECT * from designer ORDER BY  lastname, firstname;

	UPDATE designer SET firstname = :firstName, lastname = :lastName, country = :country WHERE ID = :designerID;

//-- Edit a video
	SELECT g.title AS gametitle, v.*
	FROM video v INNER JOIN gamevideo gv ON v.id = gv.videoID
	INNER JOIN game g ON gv.gameid = g.id
	ORDER BY g.gametitle, v.title;

	UPDATE video SET title = :title, url = :url, type = :type WHERE ID = :videoID;

//-- Edit a mechanic
	SELECT * from mechanic ORDER BY mechanic;

	UDPATE mechanic SET mechanic = :mechanic WHERE ID = :mechanicID;

//-- Get report of all games
	SELECT g.id as gameid, g.title, g.minplayers, g.maxplayers, g.minage, g.playtime, 
		g.rating, g.timesplayed, g.bggid, d.firstname+' '+d.lastname AS designer
	FROM game g LEFT JOIN designer d ON g.id = d.gameid
	ORDER BY g.title;

//-- Get report of game versions by game
SELECT g.id as gameid, g.title, g.year, d.firstname+' '+d.lastname AS designer, p.publisher
FROM game g LEFT JOIN designer d ON g.id = d.gameid
INNER JOIN publisher p ON gv.publisherid = p.id
ORDER BY g.title, g.year, p.publisher;

//-- Get report of num games per publisher
SELECT p.publisher, count(g.id) AS numgames
FROM game g INNER JOIN publisher p ON gv.publisherid = p.id
GROUP BY p.publisher
ORDER BY p.publisher;

//-- Get report of num games per mechanic
SELECT m.mechanic, count(g.id) as numgames
FROM game g INNER JOIN gamemechanic gm ON g.id = gm.gameid
INNER JOIN mechanic m ON gm.mechanicid = m.id
GROUP BY m.mechanic
ORDER BY m.mechanic;

//-- Get report of num games per designer
SELECT d.firstname, d.lastname, count(g.id) as numgames
FROM game g INNER JOIN gamedesigner gd ON g.id = gd.gameid
INNER JOIN designer d ON gd.designerid = d.id
GROUP BY d.lastname, d.firstname
ORDER BY d.lastname, d.firstname;

//-- Search for games (title, publisher, or designer matches
SELECT g.id, g.title, p.name as publisher, d.firstname, d.lastname
FROM game g LEFT JOIN publisher p on g.publisherid = p.id
LEFT JOIN gamedesigner gd ON g.id = gd.gameid
LEFT JOIN designer d ON gd.designerid = d.id
WHERE (g.title LIKE ?
  OR p.name LIKE ?
  OR d.firstname LIKE ?
  OR d.lastname LIKE ?);

