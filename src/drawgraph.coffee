update = ( input ) ->
  path = "data/#{input}.json"
  d3.json path, (adjacencies) ->
    margin =
      top: 20, right: 20, bottom: 20, left: 120
    width = adjacencies.width or 920
    height = adjacencies.height or 600

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
    layout = dagreD3.layout().rankDir("TB")
    renderer.drawNode  (graph, u, svg) ->
      	oldDrawNode graph, u, svg
      	svg.attr  "id", "node-" + u
    renderer.drawEdgeLabel  (graph, e, svg) ->
      	oldDrawEdgeLabel graph, e, svg
      	svg.attr  "id", "edge-" + e
    renderer
      .layout(layout)
      .run(
        dagreD3.json.decode(nodes, edges),
        d3.select("svg g") )

d3.selectAll(".posgraph")
  .on "click", (d) ->
     update @id

update( "standard" )
