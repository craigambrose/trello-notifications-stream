JSONStream = require('JSONStream')
Trello = require("node-trello")

module.exports = (options) ->
  key = "6b64463b8e16f9f794d03aa7f76d39e0"
  token = "f1af8514621d6338478ff6af019e0916589e7a117f29b75789003e1590bd056e"
  username = 'craigambrose'
  
  trelloClient = new Trello(key, token)

  empty_func = ->
  error_handler = (error) ->
    console.log 'FOUND error'
    console.log error

  trelloClient.get("/1/members/#{username}/notifications", [], empty_func)
  .on('error', error_handler)
  .pipe(JSONStream.parse('*'))
  .on('error', error_handler)
