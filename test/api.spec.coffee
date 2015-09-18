# Dependencies
expressCjs= require '../src'
express= require 'express'

supertest= require 'supertest'
path= require 'path'

# Environment
jasmine.DEFAULT_TIMEOUT_INTERVAL= 5000
PORT= 59798
root= path.join __dirname,'fixtures'

# Specs
describe 'expressCjs',->
  server= null
  app= null
  beforeAll (done)->
    app= express()
    app.use expressCjs {root}

    server= app.listen PORT,done
  afterAll (done)->
    server.close done

  it 'GET /',(done)->
    # coffeelint: disable=max_line_length
    regexp= '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"/><title>Document</title></head><body></body></html>'
    # coffeelint: enable=max_line_length

    supertest app
    .get '/'
    .expect 200
    .expect 'Content-type','text/html; charset=utf-8'
    .expect regexp
    .end (error,response)->
      if error then done.fail error else done()
      
  it 'GET /index.js(annotated)',(done)->
    regexps= [
      /this===coffee\(script\)/
      /.controller\("annotate",\["\$scope",function/
      /<string>of jade<\/string>/
    ]

    supertest app
    .get '/index.js'
    .expect 200
    .expect 'Content-type','application/javascript'
    .expect regexps[0]
    .expect regexps[1]
    .end (error,response)->
      if error then done.fail error else done()

  it 'GET /index.css',(done)->
    regexps= [
      /^html,body,div,span,applet,object,iframe,h1,h2,h3,h4,h5,h6/ # preface of meyer-reset
      /font-size:10vw/
    ]

    supertest app
    .get '/index.css'
    .expect 200
    .expect 'Content-type','text/css; charset=utf-8'
    .expect regexps[0]
    .expect regexps[1]
    .end (error,response)->
      if error then done.fail error else done()
