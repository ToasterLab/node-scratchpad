express = require('express')
logger = require('morgan')
bodyParser = require('body-parser')
fs = require('fs')
path = require('path')
fileCleaner = require('sanitize-filename')
app = express()

###
		app.configuration
###

# log all requests to server
app.use logger('dev')

# support JSON-encoded bodies
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: true)

# serve up all styles & scripts
app.use '/', express.static(path.join(__dirname, 'css'))
app.use '/', express.static(path.join(__dirname, 'scripts'))

###
		app.routes
###

app.get '/', (req, res) ->
  res.sendFile path.join(__dirname + '/views/index.html')
  
# about this app
app.get '/about', (req, res) ->
  res.sendFile path.join(__dirname + '/views/about.html')
  
# don't clutter up my view files
app.get '/bulma.css', (req, res) ->
  res.sendFile path.join(__dirname + '/node_modules/bulma/css/bulma.css')
app.get '/bulma.css.map', (req, res) ->
  res.sendFile path.join(__dirname + '/node_modules/bulma/css/bulma.css.map')
app.get '/vue.js', (req, res) ->
  res.sendFile path.join(__dirname + '/node_modules/vue/dist/vue.js')
app.get '/vue-resource.js', (req, res) ->
  res.sendFile path.join(__dirname + '/node_modules/vue-resource/dist/vue-resource.js')

###
		main logic
###

app.get '/view/all', (req, res) ->
  fs.readdir path.join(__dirname, 'data'), (err, list) ->
    data = []
    if err
      console.log(err)
    else
      list.forEach (v, i) ->
        if path.extname(v) == '.txt'
          data.push v
    res.send JSON.stringify('files': data)
  return

app.get '/view/:secretcode', (req, res) ->
  secretcode = req.params.secretcode
  file = fs.readFile(path.join(__dirname, 'data', secretcode + '.txt'), "utf8", (err, data) ->
    if err
      console.log(err)
      fs.writeFile(path.join(__dirname, 'data', secretcode + '.txt'), "", () =>
	      res.send JSON.stringify(
	      	'status': 'fail'
	      	'message': '')
	    )
    else
      res.send JSON.stringify('message': data)
  )
  return
app.post '/save/:secretcode', (req, res) ->
  secretcode = fileCleaner(req.params.secretcode)
  contents = req.body.message
  file = fs.writeFile(path.join(__dirname, 'data', secretcode + '.txt'), contents, { encoding: 'utf8'}, (err) ->
    if err
      console.log(err)
    else
      res.send JSON.stringify(
        'status': 'success'
        'filename': secretcode)
  )
  return
  
app.listen process.argv[2], ->
  console.log 'Listening on http://localhost:', process.argv[2]