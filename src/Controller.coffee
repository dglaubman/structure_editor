root = exports ? window

class root.Controller

  comm = undefined

  constructor: (@model, @graphView, @statView, @log) ->
    @modelRev =0

  start: (callback) =>
    getTicket (ticket) =>
      comm = new Communicator( @log, messageHandler this)
      comm.connect config, ticket, callback

  modelName: -> "#{@modelBaseName}.#{@modelRev}"

  updateModel: (text, name) ->
    @stop()
    if name
      @modelBaseName = name
    @modelRev++
    @model.update text

    @graphView.modelChanged @model
    @statView.modelChanged @model, @modelName()
    @subscribe()

  subscribe: () ->
    comm.startSubscription @modelName(), @model.cmds()

  stat: (track, position, losses) ->
    return @log.write "error: stat expected track #{@track}, rec'd #{track}" unless track is @track
    @statView.observe position, losses

  ready: (route, track) ->
    @log.write "#{route} on #{track}"
    @track = track

  # read in a position graph, and render it
  load: (name) =>
    path = "./data/#{name}.structure"
    d3.text path, (text) =>
      d3.select( "#editor" ).text () -> @value = text
      @updateModel text, name

  run: (numIter) ->
    sequence = Date.now()
    @model.startCmds()
      .forEach (cmd) =>
        comm.startFeed cmd.key, @track, cmd.value, numIter, sequence

  stop: () ->
    return if not @track
    sequence = Date.now()
    @model.stopCmds()
      .forEach (cmd) =>
        comm.startFeed cmd.key, @track, cmd.value, 1, sequence

  stopped: (type, name) ->
    @log.write "recd stopped signal for #{type} #{name}"

messageHandler = (controller) -> (m) ->
  topic = m.args.routingKey
  body = m.body.getString(Charset.UTF8)
  switch m.args.exchange
    when config.serverX
      serverDispatcher controller, body

getTicket = (callback) ->
  d3.text './ts', (err, ticket) ->
    if err
      log.write err
    else
      callback ticket
