root = exports ? window

class StatView

  constructor: (@log) ->
    @positions = {}
    @values = []

  modelChanged: (model, name) ->
    @model = model
    nodes = @model.graph().nodes
    leaves = @model.graph().initial
    @values =
      nodes.map (node) ->
        key = node.value.key
        [ leaves[key] or "" ]
    nodes.forEach (node) =>
      @positions[ encode node.value.key ] = "#node-#{node.id} .stat text"

    d3.selectAll("g.node")
        .data( @values )
      .selectAll("g.stat")
        .data( (d) -> d )
      .enter()
        .append("g")
        .classed("stat", true)
        .attr("transform", "translate(0, 40)")
        .append("text")
        .text (d) ->
          format d

  observe: (position, losses) ->
    if losses.length > 0
      d3.select(@positions[position]).text format  losses[losses.length - 1]

  format = (number) ->
    switch
      when number >= 1000000000
        "#{(number / 1000000000).toFixed(2)}B"
      when number >= 1000000
        "#{(number / 1000000).toFixed(2)}M"
      when number >= 1000
        "#{(number / 1000).toFixed(1)}K"
      when number is ""
        ""
      when number < 1
        "0"
      else
        "#{(+number).toFixed(0)}"


root.StatView = StatView