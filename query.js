#-------------------------------------
# ex.) Mongo Query by JavaScript
# Author: Rui Bando
#-------------------------------------
//get explain
var explain = db.test.find().explain();
printjson(explain);

var query = { created_on : ISODate("2012-05-15T15:22:02.853Z") };
//db.test.find(query).limit(10).forEach(function(){ print("name"); } );
db.test.find(query).forEach(printjson);

var where = "{ created_on : ISODate("2012-05-15T15:22:02.853Z") }, {id:1}"
db.test.find(where).forEach(printjson);

var select = { id:1 }
db.test.find(query, select).forEach(printjson);

//Use Cursor
var query = db.test.find( { created_on : ISODate("2012-05-15T15:22:02.853Z") } );
while (query.hasNext()){
    printjson(query.next())
};