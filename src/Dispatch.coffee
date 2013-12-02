# Dispatches messages from serverX exchange to view
serverDispatcher = (controller, topic, body) ->

  # topic :=   [ engine | trigger ] . [ ready | stopped | stat ]
  [ serverType, state ] = topic.split '.'

  switch state

    when 'stat'
      #  body :=   rak|#{rak}|pid|#{pid}|loss|#{currentLoss}
      [ _1, rak, _2, pid, _3, loss ]  =  body.split "|"
      controller.stat pid, loss.split ','

    when 'stopped'
      controller.stopped body

# Dispatches messages from signalX exchange to view
signalDispatcher = (controller, topic, body) ->

  controller.dataReady( topic, JSON.parse body )

root = exports ? window
root.serverDispatcher = serverDispatcher
root.signalDispatcher = signalDispatcher

