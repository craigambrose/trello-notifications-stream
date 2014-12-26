describe 'Polling for trello notifications', ->
  describe 'no notifications present', ->
    it 'does nothing'

  describe 'with a new notification', ->
    it 'posts it to glint as an activity'

  describe 'with a notification we have already posted to glint', ->
    it "doesn't post it again"
