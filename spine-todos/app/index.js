var app, assets, express, port, stylus;

express = require('express');

stylus = require('stylus');

assets = require('connect-assets');

app = express();

app.use(assets());

app.set('view engine', 'jade');

app.get('/', function(req, resp) {
  return resp.render('index');
});

port = process.env.PORT || process.env.VMC_APP_PORT || 3000;

app.listen(port, function() {
  return console.log("Listening on " + port + "\nPress CTRL-C to stop server.");
});
