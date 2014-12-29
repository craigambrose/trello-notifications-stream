notificationStream = require('./current_trello_notification_stream')
streamingPoller = require('streaming-poller')
unique = require('unique-stream')

module.exports = (options = {}) ->
  interval = options.interval || (1000 * 60 * 15)
  keyStore = options.keyStore || null
  currentStreamOptions = {
    key: options.key,
    token: options.token,
    username: options.username
  }

  streamFactory = () ->
    notificationStream(currentStreamOptions)
  
  poller = streamingPoller streamFactory, interval: interval

  poller.pipe(unique('id'), keyStore)
