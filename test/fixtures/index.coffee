fs= require 'fs'
require './components'
require './components/index.jade'
text= fs.readFileSync __dirname+'/assets/asset.txt'

app= angular.module 'myApp',[]
app.controller 'annotate',($scope)->
  console.log '$scope is alive'
