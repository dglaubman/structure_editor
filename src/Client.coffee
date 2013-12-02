$ ->
  #
  semver = "0.1.1"            # Semantic versioning - semver.org
  log = new Log( $("#console") )
  log.write "Starting up ..."

  # Hook up controls on page
  $("#clear").on 'click', ->
    log.clear()

  $("#start")
    .on "click", (d) ->
      comm.startRak "travelers"

  $(".posgraph")
    .on "click", (d) ->
      update @id

  $("#direction")
    .on "click", (d) ->
      toggle()
      render graph

  $("#node_sep_up")
    .on "click", (d) ->
      nodeSep 30
      render graph


  # Hook up controller and events for array of server widgets
  widgets = new Controller log
  widgets.stopServer = (name)  => comm.publish( config.workX, "stop #{name}", config.execQ )

  messageHandler = (m) ->
    topic = m.args.routingKey
    body = m.body.getString(Charset.UTF8)
    switch m.args.exchange
      when config.signalX
        signalDispatcher widgets, topic, body
      when config.serverX
        serverDispatcher widgets, topic, body
    log.write body

  comm = new Communicator( log, messageHandler )
  comm.connect config, config.credentials

  update("standard")
