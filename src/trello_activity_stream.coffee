Readable = require('readable-stream').Readable

class TrelloActivityStream extends Readable
  constructor: (options) ->
    options.objectMode = true
    super(options)

  _read: () ->
    true

module.exports = (options) ->
  new TrelloActivityStream(options)