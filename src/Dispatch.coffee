root = exports ? window

# Dispatches messages from serverX exchange to view
root.serverDispatcher = (controller, topic, body) ->

  # topic :=   [ engine | trigger ] . [ ready | stopped | stat ]
  [ serverType, state ] = topic.split '.'

  switch state

    when 'stat'
      #  body :=   rak|#{rak}|name|#{name}|loss|#{currentLoss}
      [ _1, rak, _2, name, _3, loss ]  =  body.split "|"
      controller.stat name, loss.split ','

    when 'ready'
      #  body :=   dot|#{dot}|rak|#{rak}|pid|#{pid}
      [ _1, sender, _2, dot, _3, rak ]  =  body.split "|"
      controller.ready sender, dot, rak

    when 'stopped'
      controller.stopped body

_origin = ""
root.origin = (args) ->
  if args
    _origin = args
  else
    _origin



