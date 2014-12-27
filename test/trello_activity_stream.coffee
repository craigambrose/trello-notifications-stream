nock = require('nock')
trelloActivityStream = require('../')
expect = require('chai').expect

describe 'Reading for a TrelloActivityStream', ->

  commentCard = {
    "id": "549a441b2b44209c498898d9",
    "unread": true,
    "type": "commentCard",
    "date": "2014-12-24T04:42:03.678Z",
    "data": {
        "text": "Initial thoughts on the approach to this in the attached Word doc.",
        "card": {
            "shortLink": "GJGTBRY0",
            "idShort": 374,
            "name": "T374 Create automated test for Contents Drawer on selection of test docs",
            "id": "54966e469745981044ca4fc6"
        },
        "board": {
            "shortLink": "FO98bRzg",
            "name": "Pagemap Dev",
            "id": "52b22536953920ef220020bf"
        }
    },
    "idMemberCreator": "52b2268857887c135d001e9b",
    "memberCreator": {
        "id": "52b2268857887c135d001e9b",
        "avatarHash": "b44ca6979b6387431323664ee46d75c7",
        "fullName": "Simon Stockdale",
        "initials": "SS",
        "username": "simonstockdale"
    }
  }

  mockTrelloNotifications = (body) ->
      nock('https://trello.com')
      .get('/1/members/craigambrose/notifications')
      .reply(200, body)

  onFirstStreamObject = (stream, options, handler) ->
    stream.on 'data', (datum) ->
      handler(datum)

    setTimeout(handler, options.timeout)

  describe 'no notifications present', ->
    it 'does nothing', (done) ->
      mockTrelloNotifications []

      stream = trelloActivityStream(
        token: 'f1af8514621d6338',
        poll_frequency: 10 * 60
      )

      onFirstStreamObject stream, timeout: 1000, (result) ->
        if result
          done(new Error("should never receive data"))
        else
          done()

  describe 'with a new notification', ->
    it 'emit activity from stream', (done) ->
      mockTrelloNotifications [commentCard]

      stream = trelloActivityStream(
        token: 'f1af8514621d6338',
        poll_frequency: 10 * 60
      )

      onFirstStreamObject stream, timeout: 1000, (result) ->
        expect(result).to.deep.equal([{
          verb: "commentCard"
        }])     




  describe 'with a notification we have already posted to glint', ->
    it "doesn't post it again"
