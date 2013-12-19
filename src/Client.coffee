# client -- application entry point - hooks up handlers and controls

log = new Log( d3.select("#console") )
log.write "Starting up ..."

currentGraph = "standard"

# get timestamp from server. This will be used to differentiate requests from different clients
ticket = -> log.write "Ticket undefined"
d3.text './ts', (err, now) ->
  if err
    log.write err
  else
    ticket = -> now
    comm.connect config, config.credentials, ticket()


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
    comm.startSubscription currentGraph, ticket()

d3.selectAll(".posgraph")
  .on "click", graphClickHandler

d3.select("#direction")
  .on "click", (d) ->
    toggle()

# Hook up controller
controller = new Controller log

controller.stopServer = (name)  =>
  comm.publish( config.workX, "stop #{name}", config.execQ )

messageHandler = (m) ->
  topic = m.args.routingKey
  body = m.body.getString(Charset.UTF8)
  switch m.args.exchange
    when config.serverX
      serverDispatcher controller, body

comm = new Communicator( log, messageHandler)

# Load the Standard positions graph
graphClickHandler.call( document.getElementById currentGraph )
