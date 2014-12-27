notificationStream = require('./trello_notification_stream')
streamingPoller = require('streaming_poller')

module.exports = (options = {}) ->
  interval = options.interval || (1000 * 10)
  poller = streamingPoller notificationStream, interval: interval

  