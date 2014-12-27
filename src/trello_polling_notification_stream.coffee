NotificationStream = require('./trello_notification_stream')

Readable = require('readable-stream').Readable

class TrelloPollingNotificationStream extends Readable
  constructor: (options = {}) ->
    options.objectMode = true
    @notifications = NotificationStream()
    super(options)

  _read: () ->
    @notifications.read()

module.exports = (options) ->
  new TrelloPollingNotificationStream(options)
