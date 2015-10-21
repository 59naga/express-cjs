# Dependencies
Promise= require 'bluebird'
express= require 'express'
prepareResponse= require 'prepare-response'

browserify= require 'browserify-middleware'
jade= require 'jade'
stylus= require 'stylus'
koutoSwiss= require 'kouto-swiss'

path= require 'path'
fs= require 'fs'

# Public
expressCjs= ({
  cwd
  debug
  bundleExternal
  jadeOptions
  useReactify
  useNgannotate
  usePlainJadeify
  useBrfs
}={})->
  cjs= express.Router()

  # Defaults
  cwd?= process.cwd()
  debug?= process.env.NODE_ENV isnt 'production'
  bundleExternal?= true
  useReactify?= true
  useNgannotate?= true
  usePlainJadeify?= true
  useBrfs?= true

  # Setup transformers
  transformers= []
  if useReactify
    transformers.push 'coffee-reactify'
  else
    transformers.push 'coffeeify'

  if useNgannotate
    transformers.push ['browserify-ngannotate',{ext:'.coffee'}]

  if usePlainJadeify
    transformers.push 'plain-jadeify'

  if useBrfs
    transformers.push 'brfs'

  # /
  htmlPromise= null
  cjs.get '/',(req,res,next)->
    htmlPromise= null if debug
    htmlPromise?= new Promise (resolve)->
      filename= cwd+path.sep+'index.jade'
      jadeOptions?= {}
      jadeOptions.pretty?= debug

      html= jade.renderFile filename,jadeOptions
      
      resolve prepareResponse html,{'content-type':'html'}

    htmlPromise.then (prepare)->
      prepare.send req,res,next

  # /index.js
  browserify.settings 'basedir',path.resolve __dirname,'..'
  browserify.settings 'transform',transformers
  browserifyMiddleware= browserify cwd+path.sep+'index.coffee',{
    extensions: ['.coffee','.cjsx']
    bundleExternal
  }
  cjs.get '/index.js',browserifyMiddleware

  # /index.css
  cssPromise= null
  cjs.get '/index.css',(req,res,next)->
    cssPromise= null if debug
    cssPromise?= new Promise (resolve,reject)->
      styl= cwd+path.sep+'index.styl'
      stylData= fs.readFileSync styl,'utf8'

      stylus stylData
      .set 'filename',styl
      .set 'sourcemap',if debug then {inline:yes} else false
      .set 'compress',not debug
      .use koutoSwiss()
      .import 'kouto-swiss'
      .render (error,css)->
        unless error
          resolve prepareResponse css,{'content-type':'css'}

        else
          reject error

    cssPromise.then (prepare)->
      prepare.send req,res,next

  cjs

module.exports= expressCjs
