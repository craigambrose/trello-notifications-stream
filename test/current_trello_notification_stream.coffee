nock = require('nock')
trelloNotificationStream = require('../src/current_trello_notification_stream')
expect = require('chai').expect
fs = require('fs')

describe 'Reading from a CurrentTrelloNotificationStream', ->
  commentCard = JSON.parse(fs.readFileSync('./test/fixtures/notifications/commentCard.json'))

  trelloOptions = {
    key: 'abc',
    token: 'f1af8514621d6338',
    username: 'fred'
  }

  mockTrelloNotifications = (body) ->
    nock.disableNetConnect()

    nock('https://api.trello.com')
    .get('/1/members/fred/notifications?key=abc&token=f1af8514621d6338')
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

      stream = trelloNotificationStream(trelloOptions)

      onFirstStreamObject stream, timeout: 1000, (result) ->
        if result
          done(new Error("should never receive data"))
        else
          done()

  describe 'with a notification', ->
    it 'emit notification from stream', (done) ->
      mockTrelloNotifications [commentCard]

      stream = trelloNotificationStream(trelloOptions)

      onFirstStreamObject stream, timeout: 1000, (result) ->
        expect(result).to.deep.equal(commentCard)   
        done()  

