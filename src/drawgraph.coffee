root = exports ? window
compile = require( './public/js/backend.js' )

prop = (val) ->
  _ = val
  (v) ->
    if v then _ = v else _

root.structure = prop { name: "standard" }

# remove previous rendering and render current graph
root.render = render = (structure) ->
  { graph, cmds } = compile structure().text
  structure().dag = graph
  structure().cmds = cmds
  colors = colorBuilder()
  margin =
    top: 20, right: 20, bottom: 20, left: 20
  size = graph.nodes.length + graph.edges.length
  width = height = Math.max 600, 40 * size
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

  nodes = graph.nodes
  edges = graph.edges
  renderer = new dagreD3.Renderer()
  oldDrawNode = renderer.drawNode()
  oldDrawEdgeLabel = renderer.drawEdgeLabel()

  renderer.drawNode  (g, u, svg) ->
    key = g._nodes[u].value.key
    oldDrawNode g, u, svg
    svg.attr  "id", "node-" + u
    svg.style "fill", colors(key)

  renderer.drawEdgeLabel  (g, e, svg) ->
    oldDrawEdgeLabel g, e, svg
    val = g._edges[e].value
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

colorBuilder = () ->
  namespaces = { my: 0, Our: 0, _none_: 0 }
  index = 1
  palette = d3.scale.category20c().domain(d3.range(20))
  (key) ->
    [ns, barename] = key.split ':'
    if not barename then ns = "_none_"
    c = namespaces[ns] or= index++
    palette (c * 3) % 20

WIDE = 60
NARROW = 30
nodeSep = NARROW
root.toggleNodeSeparation = () ->
  if  nodeSep is WIDE then nodeSep = NARROW else nodeSep = WIDE
  render structure

rankDir = "TB"
root.toggleDirection = ->
    if rankDir is "TB" then rankDir = "LR" else rankDir = "TB"
    render structure
