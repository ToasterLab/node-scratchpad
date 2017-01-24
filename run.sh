#!/bin/bash

pug views
coffeebar app.coffee
coffeebar -Mo scripts scripts
node app.js 8080