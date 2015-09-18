require './components'
require './components/index.jade'

app= angular.module 'myApp',[]
app.controller 'annotate',($scope)->
  console.log '$scope is alive'
