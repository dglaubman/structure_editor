# client -- application entry point - hooks up handlers and controls

log = new Log( d3.select("#console"))
log.write "Starting up ..."

currentGraph = "standard"
graphClickHandler = (d) ->
  d3.select( "##{currentGraph}" ).classed 'selected', false
  d3.select(@).classed 'selected', true
  currentGraph = update @id

# Hook up controls on page
d3.select("#clear").on 'click', ->
  log.clear()

d3.select("#start")
  .on "click", (d) ->
    controller.subscribe currentGraph

d3.select("#runOne")
  .on "click", (d) ->
     controller.run 1

d3.select("#run")
  .on "click", (d) ->
     controller.run 1000

d3.selectAll(".posgraph")
  .on "click", graphClickHandler

d3.select("#direction")
  .on "click", (d) ->
    toggleDirection()

d3.select("#node_sep")
  .on "click", (d) ->
    toggleNodeSeparation()

d3.select("#verbose")
  .on "click", (d) ->
    log.toggle()

# Hook up controller
controller = new Controller log
controller.start ->
  # Load the Standard positions graph
  graphClickHandler.call( document.getElementById currentGraph )

