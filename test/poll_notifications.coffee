nock = require('nock')
TrelloGlint = require('../')

describe 'Polling for trello notifications', ->
  describe 'no notifications present', ->
    it 'does nothing', (done) ->
      nock('https://trello.com')
      .get('/1/members/craigambrose/notifications')
      .reply(200, [])

      stream = TrelloGlint(
        token: 'f1af8514621d6338',
        poll_frequency: 10 * 60
      )

      stream.on 'data', (datum) ->
        done(new Error("should never receive data"))

      setTimeout done, 1000

  describe 'with a new notification', ->
    it 'posts it to glint as an activity'

  describe 'with a notification we have already posted to glint', ->
    it "doesn't post it again"
