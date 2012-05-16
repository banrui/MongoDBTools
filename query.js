//get explain
var explain = db.test.find().explain();
printjson(explain);

var query = { created_on : ISODate("2012-05-15T15:22:02.853Z") };
//db.test.find(query).limit(10).forEach(function(){ print("name"); } );
db.test.find(query).forEach(printjson);

var select = { id:1 }
db.test.find(query, select).forEach(printjson);
