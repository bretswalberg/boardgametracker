
/*var mysql = require('mysql');
var pool = mysql.createPool({
  connectionLimit : 10,
  host            : 'classmysql.engr.oregonstate.edu',
  user            : 'cs340_swalberb',
  password        : '5683',
  database        : 'cs340_swalberb'
});

module.exports.pool = pool;
*/

var sqlite3 = require('sqlite3').verbose()
var md5 = require('md5')

const DBSOURCE = "games.db"

let db = new sqlite3.Database(DBSOURCE, (err) => {
    if (err) {
      // Cannot open database
      console.error(err.message)
      throw err
    }else{
        console.log('Connected to the SQLite database.')
    }
});

module.exports = db