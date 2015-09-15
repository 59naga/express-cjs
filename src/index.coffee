# Dependencies
express= require 'express'

browserify= require 'browserify-middleware'
jade= require 'jade'
stylus= require 'stylus'
koutoSwiss= require 'kouto-swiss'

path= require 'path'
fs= require 'fs'

# Public
expressCjs= ({root,debug,staticServe}={})->
  cjs= express.Router()

  # Defaults
  root?= process.cwd()
  debug?= process.env.NODE_ENV isnt 'production'
  staticServe?= yes

  # /
  cjs.get '/',(req,res)->
    filename= root+path.sep+'index.jade'
    options=
      pretty: debug
      cache: not debug
    content= jade.renderFile filename,options

    res.set 'Content-type','text/html'
    res.set 'Content-length',Buffer.byteLength content,'utf8'
    res.end content

  # /index.js
  browserify.settings.production 'minify',false
  browserify.settings 'transform',[
    'coffeeify'
    'browserify-plain-jade'
  ]
  browserifyMiddleware= browserify root+path.sep+'index.coffee',
    extensions: ['.coffee']
    bundleExternal: false
  cjs.get '/index.js',browserifyMiddleware

  # /index.css
  cssCache= null
  cjs.get '/index.css',(req,res)->
    if cssCache?
      res.set 'Content-type','text/css'
      res.set 'Content-length',Buffer.byteLength cssCache,'utf8'
      res.end cssCache
      return

    styl= root+path.sep+'index.styl'
    stylData= fs.readFileSync styl,'utf8'

    stylus stylData
    .set 'filename',styl
    .set 'sourcemap',{inline:yes}
    .set 'compress',yes
    .use koutoSwiss()
    .import 'kouto-swiss'
    .render (error,css)->
      throw error if error?

      cssCache?= css unless debug

      res.set 'Content-type','text/css'
      res.set 'Content-length',Buffer.byteLength css,'utf8'
      res.end css

  # Setup static files
  if staticServe
    cjs.use (req,res,next)->
      # Fix by https://gist.github.com/59naga/b6bb5cd3ef3e2eb6cc09
      res.set 'Content-Encoding','gzip' if req.url.match /.gz$/
      res.set 'Content-Type','text/javascript' if req.url.match /.js.gz$/

      next()
    cjs.use express.static root

  cjs

module.exports= expressCjs
