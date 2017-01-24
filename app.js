var express = require("express");
var logger = require("morgan");
var bodyParser = require("body-parser");
var fs = require("fs");
var path = require("path");
var fileCleaner = require("sanitize-filename");

var app = express();

/*
		app.configuration
*/

// log all requests to server
app.use(logger("dev"));

// support JSON-encoded bodies
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended:true}));

// serve up all styles & scripts
app.use("/",express.static(path.join(__dirname, "css")));
app.use("/",express.static(path.join(__dirname, "scripts")));

/*
		app.routes
*/

app.get("/", (req, res) => {
	res.sendFile(path.join(__dirname + "/views/index.html"));
});

// about this app
app.get("/about", (req, res) => {
	res.sendFile(path.join(__dirname + "/views/about.html"));
});

// don't clutter up my view files
app.get("/bulma.css", function(req, res){
	res.sendFile(path.join(__dirname + "/node_modules/bulma/css/bulma.css"));
});
app.get("/bulma.css.map", function(req, res){
	res.sendFile(path.join(__dirname + "/node_modules/bulma/css/bulma.css.map"));
});
app.get("/vue.js", function(req, res){
	res.sendFile(path.join(__dirname + "/node_modules/vue/dist/vue.js"));
});
app.get("/vue-resource.js", function(req, res){
	res.sendFile(path.join(__dirname + "/node_modules/vue/dist/vue.js"));
});

/*
		main logic
*/
app.get("/view/all", (req, res) => {
	fs.readdir(path.join(__dirname,"data"), (err, list) => {
		var data = [];
		if(err){
			return console.log(err);
		} else {
			list.forEach((v,i) => {
				if(path.extname(v) === ".txt"){
					data.push(v);
				}
			});
		}
		res.send(JSON.stringify({
			"files":data
		}));
	});
});

app.get("/view/:secretcode", (req, res) => {
	var secretcode = req.params.secretcode;
	var file = fs.readFile(path.join(__dirname,"data",secretcode+".txt"), {encoding:"utf8"},(err, data) => {
		if(err){
			return console.log(err);
		} else {
			res.send(JSON.stringify(
				{
					"message": data
				}));
		}
	});
});

app.post("/save/:secretcode", (req, res) => {
	var secretcode = fileCleaner(req.params.secretcode);
	var contents = req.body.message;
	var file = fs.writeFile(path.join(__dirname,"data",secretcode+".txt"), contents, {encoding:"utf8"}, (err) => {
			if(err){
				return console.log(err);
			} else {
				res.send(JSON.stringify({
					"status":"success",
					"filename":secretcode
				}));
			}
	});
	
});

app.listen(process.argv[2], () => {
	console.log("Listening on http://localhost:",process.argv[2]);
});
