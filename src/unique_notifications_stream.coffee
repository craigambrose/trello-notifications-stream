notificationStream = require('./current_trello_notification_stream')
streamingPoller = require('streaming-poller')
unique = require('unique-stream')

module.exports = (options = {}) ->
  interval = options.interval || (1000 * 10)
  keyStore = options.keyStore || null

  poller = streamingPoller notificationStream, interval: interval

  poller.pipe(unique('id'), keyStore)
