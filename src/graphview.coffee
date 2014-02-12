root = exports ? window
compile = require( 'compile' )

class GraphView

  WIDE = 60
  NARROW = 30
  colors = ->
  log = ->

  constructor: (console) ->
    @nodeSep = NARROW
    @rankDir = "TB"
    log = console

  modelChanged: (model) ->
    { @nodes, @edges } = model.graph()
    colors = colorBuilder()
    render @nodes, @edges, @nodeSep, @rankDir

  toggleNodeSeparation: () ->
    if  @nodeSep is WIDE then @nodeSep = NARROW else @nodeSep = WIDE
    render @nodes, @edges, @nodeSep, @rankDir

  toggleDirection: () ->
    if @rankDir is "TB" then @rankDir = "LR" else @rankDir = "TB"
    render @nodes, @edges, @nodeSep, @rankDir

  # remove previous rendering and render current graph
  render = (nodes, edges, nodeSep, rankDir) ->
    if not nodes or not edges
      log.write "GraphView: No model to render"
      return
    margin =
      top: 20, right: 20, bottom: 20, left: 20
    size = nodes.length + edges.length
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
        dagreD3.json.decode( nodes, edges),
        d3.select("#chart svg g") )


colorBuilder = () ->
  namespaces = { my: 0, Our: 0, _none_: 0 }
  index = 1
  palette = d3.scale.category20c().domain(d3.range(20))
  (key) ->
    [ns, barename] = key.split ':'
    if not barename then ns = "_none_"
    c = namespaces[ns] or= index++
    palette (c * 3) % 20

root = exports ? window
root.GraphView = GraphView
