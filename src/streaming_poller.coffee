through = require('through2')
pauseable = require('pauseable')

module.exports = (factory, options = {}) ->
  interval = options.interval || 1000

  result = through.obj()

  result.setInner = (source) ->
    source.pipe result, {end: false}
    return this

  factoryWithTimer = () ->
    factory().on 'end', ->            
      result.timer = pauseable.setTimeout interval, ->
        result.setInner(factoryWithTimer())

  result.on 'pause', ->
    result.timer.pause() if result.timer

  result.on 'resume', ->
    result.timer.resume() if result.timer

  result.on 'end', ->
    console.log 'end'
    if result.timer
      result.timer.clear()
      result.timer = null

  result.setInner factoryWithTimer()

  result
