fs= require 'fs'
require './components'
require './components/index.jade'
text= fs.readFileSync __dirname+'/assets/asset.txt'

# Use angular
app= angular.module 'myApp',[]
app.controller 'annotate',($scope)->
  console.log '$scope is alive'

# Use react
CommentBox= React.createClass
  render: ->
    <div className="commentBox">
      Hello, world! I am a CommentBox.
    </div>
