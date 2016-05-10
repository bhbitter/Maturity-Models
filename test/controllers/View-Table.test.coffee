View_File = require '../../src/controllers/View-Table'
Server     = require '../../src/server/Server'


describe 'controllers | Api-Controller', ->
  app       = null
  req       = null
  view_File = null

  beforeEach ->
    app = new Server().setup_Server().app
    req =
      params :
        filename: 'team-A'

    using new View_File(app:app), ->
      @.add_Routes()
      @.app.use('routes', @.router)
      view_File = @

  it 'constructor', ->
    using new View_File(app: app), ->
      @     .constructor.name.assert_Is 'View_Table'
      @.data.constructor.name.assert_Is 'Data'

  it 'add_Routes', ->
    using new View_File(app:app), ->
      @.add_Routes()
      @.router.stack.assert_Size_Is 2

  it 'table', ->
    res =
      render: (page, data)->
        page.assert_Is 'tables/bsimm-table'
        data.table.activities.Governance.assert_Is_Object()
    view_File.table(req, res)

  it.only 'table_Json', -> 
    res =
      setHeader: (key,value)->
        key  .assert_Is 'Content-Type'
        value.assert_Is 'application/json' 
      send: (data)-> 
        data.headers.assert_Is ['Governance', 'Intelligence', 'SSD', 'Deployment']
        data.rows.keys().size().assert_Is 2
        data.rows[0].size().assert_Is 8
        data.rows[0].assert_Is [ 'SM.1.1', 'Yes', 'AM1.2', 'Maybe',
                                 'AA.1.1','Maybe','PT.1.1','Maybe' ]

    view_File.table_Json(req, res)
