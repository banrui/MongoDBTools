var query = {};
db.test.find(query).limit(10).forEach(function(x){ print("name"); });