# client -- application entry point - hooks up handlers and controls

log = new Log( d3.select("#console"))
log.write "Starting up ..."

graph = new GraphView()
model = new Model()
controller = new Controller( log )

graphClickHandler = () ->
  d3.selectAll( ".posgraph" ).classed 'selected', false
  d3.select(@).classed 'selected', true
  name = @id
  path = "./data/#{name}.structure"
  d3.text path, (text) ->
#     model = new Model name, text
#     editor = new TextEditor model
#     graph = new GraphView model
    d3.select( ".editor.text" ).text () -> @value = text
    model.update text
    graph.update model
    controller.update model
#    d3.select( ".editor.label" ).text () -> @value = name

#    controller.stop()



# Hook up controls on page
d3.select("#clear").on 'click', ->
  log.clear()

d3.select("#start")
  .on "click", () ->
    controller.subscribe structure()

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

d3.selectAll(".posgraph")
  .on "click", graphClickHandler

d3.select("#model")
  .on "blur", () ->
    structure().text = @value
    structure().name += ".#{Date.now()}"
    d3.select( "window_label right" ).text () -> @value = @value + "*"
    render structure

d3.select("#direction")
  .on "click", (d) ->
    graph.toggleDirection()

d3.select("#node_sep")
  .on "click", (d) ->
    graph.toggleNodeSeparation()

d3.select("#verbose")
  .on "click", (d) ->
    log.toggle()

# Hook up controller
controller.start ->
  # Load the Standard positions graph
  graphClickHandler.call( document.getElementById 'standard' )

