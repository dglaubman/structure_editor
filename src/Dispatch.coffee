# Dispatches messages from serverX exchange to view
serverDispatcher = (controller, topic, body) ->

  # topic :=   [ engine | trigger ] . [ ready | stopped ]
  [ serverType, state ] = topic.split '.'

  switch state

    when 'ready'
      #  body :=   name: AAA/NN, load: NN
      s =  body.replace( /\s/g, '')               # squeeze out whitespace
      [ _1, name, _2, load ]  =  s.split /|/g  # split on : and ,
      controller.ready serverType, name, load

    when 'stopped'
      controller.stopped body

# Dispatches messages from signalX exchange to view
signalDispatcher = (controller, topic, body) ->

  controller.dataReady( topic, JSON.parse body )

root = exports ? window
root.serverDispatcher = serverDispatcher
root.signalDispatcher = signalDispatcher

