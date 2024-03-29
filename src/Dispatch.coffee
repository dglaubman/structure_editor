root = exports ? window

# Dispatches messages from serverX exchange to view
root.serverDispatcher = (controller, body) ->

  [ state, msg... ] = body.split '|'

  switch state

    when 'stat'
      [ _1, track, _2, position, _3, lossez ]  =  msg
      losses = lossez.split ','
      controller.stat track, position, losses

    when 'ready'
      [ _1, route, _2, track ] = msg
      controller.ready route, track

    when 'stopped'
      [ _1, type, _2, name ] = msg
      controller.stopped type, name
