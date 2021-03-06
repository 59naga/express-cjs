# Dependencies
Promise= require 'bluebird'
expressCjs= require '../src'
express= require 'express'

supertest= require 'supertest'

path= require 'path'
fs= require 'fs'

escapeRegExp= require 'lodash.escaperegexp'

# Environment
jasmine.DEFAULT_TIMEOUT_INTERVAL= 5000
PORT= 59798
cwd= path.join __dirname,'fixtures'

# Specs
describe 'expressCjs',->
  describe 'Default',->
    server= null
    app= null
    beforeAll (done)->
      app= express()
      app.use expressCjs {cwd}

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
      .expect 'Content-type','text/html'
      .expect 'etag','c1d353fafeefd2f2af7cfbdf2df3a492'
      .expect 'content-encoding','gzip'
      .expect 'content-length',108
      .expect 'date',/.+?/
      .expect regexp
      .end (error,response)->
        if error then done.fail error else done()
        
    it 'GET /index.js(use browserify-ngannotate/plain-jadeify/brfs)',(done)->
      base64text= (fs.readFileSync __dirname+'/fixtures/assets/asset.txt').toString 'base64'

      regexps= [
        # coffeeify
        /this===coffee\(script\)/
        # coffee-react
        /React.createElement\("div",{className:"commentBox"},/
        # browserify-ngannotate
        /.controller\("annotate",\["\$scope",function/
        # plain-jadeify
        /<string flex>of jade<\/string>/
        # brfs
        new RegExp escapeRegExp base64text
      ]

      supertest app
      .get '/index.js'
      .expect 200
      .expect 'Content-type','application/javascript'
      .expect regexps[0]
      .expect regexps[1]
      .expect regexps[2]
      .expect regexps[3]
      .expect regexps[4]
      .end (error,response)->
        if error then done.fail error else done()

    it 'GET /index.css',(done)->
      regexps= [
        /^html,body,div,span,applet,object,iframe,h1,h2,h3,h4,h5,h6/ # preface of meyer-reset
        /font-size:10vw/
        /\}$/ # Not include sourcemap
      ]

      supertest app
      .get '/index.css'
      .expect 200
      .expect 'Content-type','text/css'
      .expect 'etag','ea2b05def8cba306857d3ce80b31c87a'
      .expect 'content-encoding','gzip'
      .expect 'content-length',449
      .expect 'date',/.+?/
      .expect regexps[0]
      .expect regexps[1]
      .expect regexps[2]
      .end (error,response)->
        if error then done.fail error else done()

    it 'always 404',(done)->
      promises=
        for i in [0...100]
          do (i)->
            new Promise (resolve,reject)->
              supertest app
              .get '/'+i
              .expect 404
              .end (error,response)->
                unless error then resolve response else reject error

      Promise.all promises
      .then -> done()
      .catch (errors)-> done.fail errors

  describe 'Use html5Mode',->
    html5Mode= yes

    server= null
    app= null
    beforeAll (done)->
      app= express()
      app.use expressCjs {cwd,html5Mode}

      server= app.listen PORT,done
    afterAll (done)->
      server.close done

    it 'always 200',(done)->
      # coffeelint: disable=max_line_length
      regexp= '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"/><title>Document</title></head><body></body></html>'
      # coffeelint: enable=max_line_length
      promises=
        for i in [0...100]
          do (i)->
            new Promise (resolve,reject)->
              supertest app
              .get '/'+i
              .expect 200
              .expect 'Content-type','text/html'
              .expect 'etag','c1d353fafeefd2f2af7cfbdf2df3a492'
              .expect 'content-encoding','gzip'
              .expect 'content-length',108
              .expect 'date',/.+?/
              .expect regexp
              .end (error,response)->
                unless error then resolve response else reject error

      Promise.all promises
      .then -> done()
      .catch (errors)-> done.fail errors
