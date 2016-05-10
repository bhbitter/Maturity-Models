Routes   = require '../../src/server/Routes'
Server   = require '../../src/server/Server'
expresss = require 'express' 

describe 'server | Routes', ->
  
  app = null
  
  beforeEach ->
    app = new Server().setup_Server().app
    
  it 'construtor', ->
    using new Routes(app: 'app'),->
      @.options.assert_Is app: 'app'
      @.app.assert_Is 'app'

  it 'list', ->
    using new Routes() , ->
      @.list().assert_Is []
    
    using new Routes(app: app) , ->
      @.list().assert_Is 	[ '/', '/ping', '/d3-radar', '/live-radar' ]

  it 'list (with Router() routes)', ->
    app._router.stack.size().assert_Is 6                     # default mappings

    router = expresss.Router()
    router.get  '/test---123', ->                              # create new routes using Router
    router.post '/test---456', ->
    app   .use  '/aaaa---789', router                          # add it to the main route
    app._router.stack.size().assert_Is 7

    #console.log app._router.stack
    using new Routes(app: app) , ->
      @.list().assert_Is [ '/'
                           '/ping'
                           '/d3-radar'
                           '/live-radar'
                           '/aaaa---789/test---123'
                           '/aaaa---789/test---456' ]
      
        
