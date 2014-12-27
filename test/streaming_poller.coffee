StreamingPoller = require('../src/streaming_poller.coffee')
streamify = require('stream-array')
expect = require('chai').expect

describe 'Streaming Poller', ->
  it 'emits the same thing as the internal stream', (done) ->
    streamFactory = () ->
      streamify([4,5,6])

    poller = StreamingPoller streamFactory, interval: 2000

    sofar = []

    poller.on 'data', (datum) ->
      sofar.push(datum)

    setTimeout ->
      expect(sofar).to.deep.eq([4,5,6])
      poller.pause()
      done()
    , 1000

  it 'emits again after interval', (done) ->
    streamFactory = () ->
      streamify([4,5,6])

    poller = StreamingPoller streamFactory, interval: 500

    sofar = []

    poller.on 'data', (datum) ->
      sofar.push(datum)

    poller.read(0)

    setTimeout ->
      expect(sofar).to.deep.eq([4,5,6,4,5,6])
      poller.pause()
      done()
    , 600

  it 'stops emitting while paused', (done) ->
    streamFactory = () ->
      streamify([4,5,6])

    poller = StreamingPoller streamFactory, interval: 400

    sofar = []

    poller.on 'data', (datum) ->
      sofar.push(datum)
      poller.pause()

    setTimeout ->
      expect(sofar).to.deep.eq([4])
      done()
    , 600    

  it "shouldn't normally end", (done) ->
    streamFactory = () ->
      streamify([4,5,6])

    poller = StreamingPoller streamFactory, interval: 1000

    sofar = []

    timer = setTimeout ->
      done()
    , 600    

    poller.on 'end', () ->
      clearTimeout(timer)
      done(new Error("Received end event"))

