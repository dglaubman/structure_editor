# client -- application entry point - hooks up handlers and controls

log = new Log( d3.select("#console"))
model = new Model(log)
graphView = new GraphView(log)
statView = new StatView(log)
controller = new Controller( model, graphView, statView, log )

log.write "Starting up ..."

graphClickHandler = () ->
  d3.selectAll( ".posgraph" ).classed 'selected', false
  d3.select(@).classed 'selected', true
  name = @id
  path = "./data/#{name}.structure"
  d3.text path, (text) ->
    d3.select( "#editor" ).text () -> @value = text
    controller.updateModel text, name


# Hook up controls on page

# Choose a new structure
d3.selectAll(".posgraph")
  .on "click", graphClickHandler

d3.select("#start")
  .on "click", () ->
    controller.subscribe()

d3.select("#stop")
  .on "click", () ->
    controller.stop()

d3.select("#run_one")
  .on "click", () ->
     controller.run 1

d3.select("#run_many")
  .on "click", () ->
     controller.run 1000

d3.select("#run_many2")
  .on "click", () ->
     controller.run 10000

d3.select("#editor")
  .on "blur", () ->
    controller.updateModel @value

d3.select("#direction")
  .on "click", (d) ->
    graph.toggleDirection()

d3.select("#node_sep")
  .on "click", (d) ->
    graph.toggleNodeSeparation()

# Logging controls
d3.select("#verbose")
  .on "click", (d) ->
    log.toggle()
d3.select("#clear").on 'click', ->
  log.clear()


# Hook up controller
controller.start ->
  # Load the Standard positions graph
  graphClickHandler.call( document.getElementById 'standard' )

