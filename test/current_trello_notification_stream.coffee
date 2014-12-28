nock = require('nock')
trelloNotificationStream = require('../src/current_trello_notification_stream')
expect = require('chai').expect
fs = require('fs')

describe 'Reading from a CurrentTrelloNotificationStream', ->
  commentCard = JSON.parse(fs.readFileSync('./test/fixtures/notifications/commentCard.json'))

  mockTrelloNotifications = (body) ->
    nock.disableNetConnect()

    nock('https://api.trello.com')
    .get('/1/members/craigambrose/notifications?key=6b64463b8e16f9f794d03aa7f76d39e0&token=f1af8514621d6338478ff6af019e0916589e7a117f29b75789003e1590bd056e')
    .reply(200, body)

  onFirstStreamObject = (stream, options, handler) ->
    timeout = setTimeout(-> 
      handler(null)
    , options.timeout)

    stream.on 'data', (datum) ->
      clearTimeout timeout
      handler(datum)


  describe 'no notifications present', ->
    it 'does nothing', (done) ->
      mockTrelloNotifications []

      stream = trelloNotificationStream(
        token: 'f1af8514621d6338',
        poll_frequency: 10 * 60
      )

      onFirstStreamObject stream, timeout: 1000, (result) ->
        if result
          done(new Error("should never receive data"))
        else
          done()

  describe 'with a notification', ->
    it 'emit notification from stream', (done) ->
      mockTrelloNotifications [commentCard]

      stream = trelloNotificationStream(
        token: 'f1af8514621d6338',
        poll_frequency: 10 * 60
      )

      onFirstStreamObject stream, timeout: 1000, (result) ->
        expect(result).to.deep.equal(commentCard)   
        done()  

