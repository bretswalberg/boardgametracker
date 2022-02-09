var express = require('express');
var app = express();
var db = require('./dbcon.js');
var portnum = 8181			
var handlebars = require('express-handlebars').create({defaultLayout:'main'});

var bodyParser = require("body-parser");
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.use(express.static('static'));

app.engine('handlebars', handlebars.engine);
app.set('view engine', 'handlebars');
app.set('port', portnum);


// render homepage on initial GET request
app.get('/', function(req, res, next) {
    res.render('home');
});



/*-------------------------
  GAME HANDLERS
-------------------------*/
app.get('/viewgame', function(req, res, next) {
	var sqlPublisher = "SELECT g.*, p.name AS publisher " + 
					" FROM game g LEFT JOIN publisher p ON g.publisherid = p.id " + 
					" WHERE g.id = ?"
	var sqlDesigner = "SELECT d.* " + 
					" FROM designer d INNER JOIN gamedesigner gd ON d.id = gd.designerid " + 
					" WHERE gd.gameid = ?"
	var sqlMechanic = "SELECT m.* " + 
					" FROM mechanic m INNER JOIN gamemechanic gm ON m.id = gm.mechanicid " + 
					" WHERE gm.gameid = ?"
	var sqlVideo = "SELECT v.* " + 
					"FROM video v INNER JOIN gamevideo gv ON v.id = gv.videoid " + 
					"WHERE gv.gameid = ?"
	var sqlGamePhoto = "SELECT * FROM gamephoto WHERE gameid = ?"

	db.all(sqlPublisher, [req.query.gid], (err, game) => {
        if (err) {
            next(err);
            return;
        }
		db.all(sqlDesigner, [req.query.gid], (err, des) => {
			if (err) {
				next(err);
				return;
			}
			db.all(sqlMechanic, [req.query.gid], (err, mech) => {
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
        				res.render('view-game', {game: game[0], designers: des, mechanics: mech, videos: vid, photos: photo});
					});
				});
			});
		});
	});										
});

app.get('/viewgames', function(req, res, next) {
	var sql = "SELECT g.*, p.name AS publisher " + 
			" FROM game g LEFT JOIN publisher p ON g.publisherid = p.id " + 
			" ORDER BY title"
	db.all(sql, [], (err, rows) => {
        if (err) {
            next(err);
            return;
        }
        res.render('view-games', {data: rows});
    });
});

app.get('/newgame', function(req, res, next) {
    var context = {};
	var sqlDesigner = "SELECT id, firstname, lastname FROM designer ORDER BY lastname, firstname"
	var sqlPublisher = "SELECT id, name FROM publisher ORDER BY name"

	db.all(sqlDesigner, [], (err, drows) => {
        if (err) {
            next(err);
            return;
        }
		db.all(sqlPublisher, [], (err, prows) => {
			if (err) {
				next(err);
				return;
			}
    		res.render('add-game', {designers: drows, publishers: prows});
		});
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
