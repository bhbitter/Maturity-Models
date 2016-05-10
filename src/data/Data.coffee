require('coffee-script/register')
json5 = require 'json5'

class Data
  constructor: ->
    @.data_Path = __dirname.path_Combine('../../data')

  files: =>
    values = []
    for file in @.data_Path.files_Recursive()
      if  file.file_Extension() in ['.json', '.json5', '.coffee']
        values.push file.remove(@.data_Path)
    values

  files_Names: =>
    (file.file_Name_Without_Extension() for file in @.files())
    
  files_Paths: =>
    @.data_Path.files_Recursive()

  find: (filename)=>
    if filename
      for file in @.files_Paths()                          # this can be optimized with a cache
        if file.file_Name_Without_Extension() is filename
          return @.data(file)
    return null

  data: (file)=>
    if file
      switch file.file_Extension()
        when '.json'
          file.load_Json()
        when '.json5'
          json5.parse file.file_Contents()
        when '.coffee'
          require file

  all_Data: =>
    values = []
    for file in @.files_Paths()
      value = @.data(file)
      if value
        values.add value

    return values
      
module.exports = Data