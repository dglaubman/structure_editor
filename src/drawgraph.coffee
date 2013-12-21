root = exports ? window

_graph = undefined
root.graph = graph = (adjacencies) ->
  if arguments.length > 0
    _graph = adjacencies
  else
    _graph

# read in a position graph, and render it
root.update = update = (input) ->
  path = "data/#{input}.json"
  d3.json path, render
  input

# remove previous rendering and render current graph
root.render = render = (adjacencies) ->
  graph adjacencies
  margin =
    top: 20, right: 20, bottom: 20, left: 20
  width = adjacencies.width or 920
  height = adjacencies.height or 900
  d3.selectAll("svg.chart")
    .remove()

  svg = d3.select("#chart")
    .append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .style("margin-left", -margin.left + "px")
      .classed("chart", true)
    .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

  nodes = adjacencies.nodes
  edges = adjacencies.edges
  renderer = new dagreD3.Renderer()
  oldDrawNode = renderer.drawNode()
  oldDrawEdgeLabel = renderer.drawEdgeLabel()

  renderer.drawNode  (graph, u, svg) ->
    oldDrawNode graph, u, svg
    svg.attr  "id", "node-" + u

  renderer.drawEdgeLabel  (graph, e, svg) ->
    oldDrawEdgeLabel graph, e, svg
    val = graph._edges[e].value
    svg.attr "class", val.type
    if val.type is "choose" then svg.attr  "class", val.tag

  layout = dagreD3.layout().nodeSep( nodeSep ).rankDir( rankDir )

  renderer
    .layout(layout)
    .run(
      dagreD3.json.decode(nodes, edges),
      d3.select("#chart svg g") )

  d3.selectAll("svg .node")
    .append('g')
    .classed('stat', true)
    .attr("transform", "translate(0, 40)")
    .append('text')
      .text( (d) -> d )

WIDE = 60
NARROW = 30
nodeSep = WIDE
root.toggleNodeSeparation = () ->
  if  nodeSep is WIDE then nodeSep = NARROW else nodeSep = WIDE
  render graph()

rankDir = "TB"
root.toggleDirection = ->
    if rankDir is "TB" then rankDir = "LR" else rankDir = "TB"
    render graph()
