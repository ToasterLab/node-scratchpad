var express = require("express");
var logger = require("morgan");
var path = require("path");

var app = express();

app.use(logger("dev"));

app.get("/", (req, res) => {
	res.sendFile(path.join(__dirname + "/views/index.html"));
});

// about this app
app.get("/about", (req, res) => {
	res.sendFile(path.join(__dirname + "/views/about.html"));
});

// serve up all styles & scripts
app.get("/",express.static(path.join(__dirname, "css")));
app.get("/",express.static(path.join(__dirname, "js")));

// don't clutter up my view files
app.get("/bulma.css", function(req, res){
	res.sendFile(path.join(__dirname + "/node_modules/bulma/css/bulma.css"));
});

app.listen(8080, () => {
	console.log("Listening on http://localhost:8080");
});
