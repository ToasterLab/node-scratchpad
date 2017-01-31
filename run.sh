#!/bin/bash

pug views
coffeebar app.coffee
coffeebar -bMo scripts scripts
node app.js 8080