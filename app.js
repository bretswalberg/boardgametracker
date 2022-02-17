const express = require('express');
const bodyParser = require("body-parser");
const handlebars = require('express-handlebars').create({defaultLayout:'main'});
const db = require('./dbcon.js');
const http = require('http');
const https = require('https');
const { response } = require('express');
const { report } = require('process');

const app = express();
const portnum = 8181			

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(express.static('static'));
app.engine('handlebars', handlebars.engine);
app.set('view engine', 'handlebars');
app.set('port', portnum);

// render homepage on initial GET request
app.get('/', (req, res) => {
    res.render('home');
});


/*-------------------------
  GAME HANDLERS
-------------------------*/
app.get('/viewgames', function(req, res, next) {
	var sql = "SELECT * " + 
			" FROM game " + 
			" ORDER BY title"
	db.all(sql, [], (err, rows) => {
        if (err) {
            next(err);
            return;
        }
        res.render('view-games', {data: rows});
    });
});

app.get('/viewgame', function(req, res, next) {
	var sqlGame = "SELECT *" + 
					" FROM game g " + 
					" WHERE id = ?"
	var sqlVideo = "SELECT v.* " + 
					"FROM video v INNER JOIN gamevideo gv ON v.id = gv.videoid " + 
					"WHERE gv.gameid = ?"
	var sqlGamePhoto = "SELECT * FROM gamephoto WHERE gameid = ?"

	db.all(sqlGame, [req.query.gid], (err, game) => {
        if (err) {
            next(err);
            return;
        }
		db.all(sqlVideo, [req.query.gid], (err, vid) => {
			if (err) {
				next(err);
				return;
			}
			db.all(sqlGamePhoto, [req.query.gid], (err, photo) => {
				if (err) {
					next(err);
					return;
				}
				res.render('view-game', {game: game[0], videos: vid, photos: photo});
			});
		});
	});								
});

app.get('/newgame', function(req, res, next) {
	res.render('add-game', {});
});

app.post('/newgame', function(req, res) {
	var sql = "INSERT INTO game " + 
			" (`title`, `year`, `publisher`, `minplayers`, `maxplayers`, " + 
			" `minage`, `playtime`, `rating`, `bggid`) " + 
			" VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
    params = [
	req.body['game-title'],
	req.body['game-year'] || null,
	req.body['game-publisher'] || null,
	req.body['game-min'] || null,
	req.body['game-max'] || null,
	req.body['game-age'] || null,
	req.body['game-time'] || null,
	req.body['game-rating'] || null,
	req.body['game-bgg'] || null
	]

	db.run(sql, params, function(err, result) {
		if (err) {
			console.error(err.stack);
            return;
        }
        return res.redirect('/viewgames');
    });
});

app.get('/importgame', (req, res) => {
	res.render('import-game', {});
});

app.post('/import_game_id', (req, res) => {
	var gameId = null;
	var bggid = req.body['gameid'];
	var json = {};

	getGame('http://localhost:3000/bgg_api/' + bggid)
	.then(function(json) {
		insertGame(json, bggid)
		.then(function(gameId) {
			console.log("game id is: " + gameId);
			res.redirect('viewgame?gid=' + gameId);
		})
		.catch(function(err) {
			console.error(err)
		})
	})
	.catch(function(err) {
		console.error(err)
	})
});


const getGame = function(url) {
	return new Promise( (resolve, reject) => {
		const request = http.get(url, (response) => {
			if (response.statusCode != 200) {
				reject(new Error('Failed to load page'));
			}
			var jsonResult = ''
			response.on('data', (d) => jsonResult += d);
			response.on('end', () => resolve(jsonResult));
		});
		request.on('error',  (err) => reject(err))
	});
};

const insertGame = function(jsonData, bggid) {
	return new Promise( (resolve, reject) => {
		console.log("'jsonData:" + jsonData);

		var jo = JSON.parse(jsonData)
		var title = jo.name
		var year = jo.yearpublished
		var image = jo.image
		var age = jo.age
		var minplayers = jo.minplayers
		var maxplayers = jo.maxplayers
		var description = jo.description
		var publisher = jo.boardgamepublisher
		var time = jo.playingtime

		var sql = "INSERT INTO game " + 
			" (`title`, `year`, `publisher`, `minplayers`, `maxplayers`, " + 
			" `minage`, `playtime`, `rating`, `bggid`, `description`) " + 
			" VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
		params = [title, year, publisher, minplayers, maxplayers,
			age, time, 0, bggid, description]

		const ins = db.run(sql, params, function(err) {
			if (err) {
				return console.log(err.message);
			}
			resolve(this.lastID);
		});
		ins.on('error',  (err) => reject(err))
	});
};

/*
		resp.on('end', () => {
			var jo = JSON.parse(jsonResult)
			var title = jo.name
			var year = jo.yearpublished
			var image = jo.image
			var age = jo.age
			var minplayers = jo.minplayers
			var maxplayers = jo.maxplayers
			var description = jo.description
			var publisher = jo.boardgamepublisher
			var time = jo.playingtime

			var sql = "INSERT INTO game " + 
				" (`title`, `year`, `publisher`, `minplayers`, `maxplayers`, " + 
				" `minage`, `playtime`, `rating`, `bggid`, `description`) " + 
				" VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
			params = [title, year, publisher, minplayers, maxplayers,
				age, time, 0, bggid, description]

			db.run(sql, params, function(err) {
				if (err) {
					return console.log(err.message);
				}
				gameId = this.lastID
				console.log("new gameid: " + gameId);
			});
		});
	}).on("error", (err) => {
		console.log("Error: " + err.message);
	});
*/

app.get('/deletegame', function(req, res, next) {
	var delPhoto = 'DELETE FROM gamephoto WHERE gameid = ?';
	var delVideo = 'DELETE FROM gamevideo WHERE gameid = ?';
	var delGame = 'DELETE FROM game WHERE id = ?';

	db.run(delPhoto, [req.query.id], function(err, result) {
		if (err) {
			console.error(err.stack);
			return;
		}
		db.run(delVideo, [req.query.id], function(err, result) {
			if (err) {
				console.error(err.stack);
				return;
			}
			db.run(delGame, [req.query.id], function(err, result) {
				if (err) {
					console.error(err.stack);
					return;
				}
				return res.redirect('/viewgames');
			});
		});
	});
});

app.get('/updategame', function(req, res, next) {
	sqlGame = 'SELECT * FROM game WHERE id = ?';
	db.all(sqlGame, [req.query.id], function(err, game) {
		if (err) {
			next(err);
			return;
		}
		res.render('update-game', {data: game[0]});
	});
});

app.post('/updategame', function(req, res, next) {
	var sql = 'UPDATE game SET title=?, year=?, publisher=?, minplayers=?, ' + 
			' maxplayers=?, minage=?, playtime=?, rating=?, bggid=? ' + 
			' WHERE id = ?';
	var params = [req.body['game-title'],
				req.body['game-year'] || null,
				req.body['game-publisher'] || null,
				req.body['game-min'] || null,
				req.body['game-max'] || null,
				req.body['game-age'] || null,
				req.body['game-time'] || null,
				req.body['game-rating'] || null,
				req.body['game-bgg'] || null,
				req.body['game-id'] ];

    db.run(sql, params, function(err, result) {
		if (err) {
			next(err);
			return;
		}
		return res.redirect('/viewgames');
   	});
});

/*-------------------------
  PHOTO HANDLERS
-------------------------*/
app.get('/viewphotos', function(req, res, next) {
	sql = 'SELECT gp.id, gp.image, gp.description, gp.gameid, g.title ' + 
		' FROM gamephoto gp INNER JOIN game g on gp.gameid = g.id ' +
		' ORDER BY g.title, gp.description';
    db.all(sql, [], function(err, rows) {
        if (err) {
            next(err);
            return;
        }
        res.render('view-photos', {data: rows});
    });
});

app.get('/newphoto', function(req, res, next) {
    db.all('SELECT id, title FROM game ORDER BY title', function(err, gamerows) {
        if (err) {
            next(err);
            return;
        }
        res.render('add-photo', {data: gamerows});
    });
});

app.post('/newphoto', function(req, res) {
	sql = 'INSERT INTO gamephoto (gameid, image, description) VALUES(?, ?, ?)';
	params = [req.body['photo-gameid'], req.body['photo-url'], req.body['photo-desc']];
	db.run(sql, params, function (err, result) {
		if (err) {
			console.error(err.stack);
			next(err);
			return;
		}
		return res.redirect('/viewphotos');
	});
});

app.get('/deletephoto', function(req, res, next) {
	db.run('DELETE FROM gamephoto WHERE id = ?', [req.query.id], function(err, rows) {
		if (err) {
			next(err);
			return;
		}
		return res.redirect('/viewphotos');
	});
});


/*----------------
OTHER HANDLERS
-----------------*/

// render homepage on initial GET request
app.get('/search', function(req, res, next) {
	const sql = "SELECT id, title, publisher " +
					"FROM game " +
					"WHERE (title LIKE ? " +
					"  OR publisher LIKE ? ) ";
	var params = ['%' + req.query.s + '%', '%' + req.query.s + '%']; 
	db.all(sql,	params, (err, rows) => {
		if (err) {
			next(err);
			return;
		}
		res.render('search', {data: rows});
	});
});

app.post('/newvideo', function(req, res) {
	mysql.pool.query("INSERT INTO video (`title`, `url`, `type`) VALUES(?, ?, ?)",
	[
	req.body['vid-title'],
	req.body['vid-url'],
	req.body['vid-type']
	],
	function (err, result) {
		if (err) {
			console.error(err.stack);
			next(err);
			return;
		}
		res.render('view-video');
	});
});

app.use(function(req,res){
  res.status(404);
  res.render('404');
});

app.use(function(err, req, res, next){
  console.error(err.stack);
  res.status(500);
  res.render('500');
});

app.listen(app.get('port'), function(){
  console.log('Express started on localhost:' + app.get('port') + '; press Ctrl-C to terminate.');
});
