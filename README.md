# trello-notifications-stream

A node.js stream that emits trello notifications for a single user, in the format output by the Trello API. 
This stream does not end, it continues to emit notifications as they occur.

## Installation

Install via npm:

```bash
$ npm install trello-notifications-stream
```

## Example

```coffeescript
notifications = require('trello-notifications-stream')
stdout = require('stdout')

options = {
  key: 'your_trello_api_key',
  token: 'your_trello_api_token',
  username: 'your_trello_username',
  interval: (1000 * 60 * 15)
}

notifications(options).pipe(stdout())
```

The notifications stream is an object stream, so here I'm piping it to the stream provided by the stdout package
which handles outputting objects to stdout. 

As the notifications stream does not end, it keeps checking for notifications by polling the trello API regularly,
the interval time suppied (in milliseconds) is the minimum time between polls. If backpressure is exerted on this
stream, or the stream is paused for any reason, then this timer is paused. So, it's possible that the actual
time between polls is longer than the supplied interval, but it should never be shorter.

Only unique notifications are returned. If it polls the notifications API again and only sees the same notification
ids, it wont return anything new. The filtering out of non-unique notifications is done by storing a list of
notification ids. By default this is done in memory, so if you create a new stream it will emit all the notification
again.

If you would like to store the keys more permanently so that you can re-start the stream and not receive 
notifications again, then pass in a key store object which supports has(key) and add(key) methods.

```coffeescript
notifications = require('trello-notifications-stream')
stdout = require('stdout')

myStore = {
  store: {}

  add: (key) ->
    @store[key] = true

  has: (key) ->
    @store[key] !== undefined
}

options = {
  key: 'your_trello_api_key',
  token: 'your_trello_api_token',
  username: 'your_trello_username',
  keyStore: myStore
}

notifications(options).pipe(stdout())
```
