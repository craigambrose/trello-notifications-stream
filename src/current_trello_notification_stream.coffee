JSONStream = require('JSONStream')
Trello = require("node-trello")

module.exports = (options) ->
  key = options.key
  token = options.token
  username = options.username
  
  trelloClient = new Trello(key, token)

  trelloClient.get("/1/members/#{username}/notifications", [], ->)
  .pipe(JSONStream.parse('*'))
