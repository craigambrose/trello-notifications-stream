Readable = require('readable-stream').Readable

class TrelloStream extends Readable
  constructor: (options) ->

    options.objectMode = true
    super(options)

  _read: () ->
    true

module.exports = (options) ->
  new TrelloStream(options)