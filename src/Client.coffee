# client -- application entry point - hooks up handlers and controls

log = new Log( d3.select("#console") )
log.write "Starting up ..."

currentGraph = ""

graphClickHandler = (d) ->
  d3.select( "##{currentGraph}" ).classed 'selected', false
  d3.select(@).classed 'selected', true
  update @id
  currentGraph = @id

# Hook up controls on page
d3.select("#clear").on 'click', ->
  log.clear()

d3.select("#start")
  .on "click", (d) ->
    comm.startRak currentGraph

d3.selectAll(".posgraph")
  .on "click", graphClickHandler

d3.select("#direction")
  .on "click", (d) ->
    toggle()
    render graph

d3.select("#node_sep_up")
  .on "click", (d) ->
    nodeSep += 10
    render graph

# Hook up controller
widgets = new Controller log

widgets.stopServer = (name)  =>
  comm.publish( config.workX, "stop #{name}", config.execQ )

messageHandler = (m) ->
  topic = m.args.routingKey
  body = m.body.getString(Charset.UTF8)
  switch m.args.exchange
    when config.signalX
      signalDispatcher widgets, topic, body
    when config.serverX
      serverDispatcher widgets, topic, body
  #log.write body

comm = new Communicator( log, messageHandler )
comm.connect config, config.credentials

# Load the Standard positions graph
graphClickHandler.call( document.getElementById "standard" )

