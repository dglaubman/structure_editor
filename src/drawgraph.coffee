root = exports ? window

root.update = update = ( input ) ->
  path = "data/#{input}.json"
  d3.json path, render

root.render = render = (adjacencies) ->
  margin =
    top: 20, right: 20, bottom: 20, left: 20
  width = adjacencies.width or 920
  height = adjacencies.height or 900
  direction = adjacencies.direction or "TB"
  d3.selectAll("svg")
    .remove()
  svg = d3.select("#chart")
    .append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .style("margin-left", -margin.left + "px")
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

  renderer
    .layout(layout)
    .run(
      dagreD3.json.decode(nodes, edges),
      d3.select("svg g") )
  graph = adjacencies


graph = undefined

layout = dagreD3.layout()

