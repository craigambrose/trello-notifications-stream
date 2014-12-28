JSONStream = require('JSONStream')
Trello = require("node-trello")

module.exports = (options) ->
  key = options.key || "6b64463b8e16f9f794d03aa7f76d39e0"
  token = options.token || "f1af8514621d6338478ff6af019e0916589e7a117f29b75789003e1590bd056e"
  username = options.username || 'craigambrose'
  
  trelloClient = new Trello(key, token)

  trelloClient.get("/1/members/#{username}/notifications", [], ->)
  .pipe(JSONStream.parse('*'))
