Readable = require('readable-stream').Readable

class TrelloNotificationStream extends Readable
  constructor: (options) ->
    options.objectMode = true
    super(options)

  _read: () ->
    true

module.exports = (options) ->
  new TrelloNotificationStream(options)