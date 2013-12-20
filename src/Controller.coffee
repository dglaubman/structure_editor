root = exports ? window

class root.Controller

  constructor: (@log) ->

  stat: (track, position, loss) ->
    @log.log "#{position}: #{loss}"
    tracks[track]?[position]?.text format loss

  ready: (route, track) ->
    @log.write "#{route} on #{track}"
    nodes = graph().nodes
    positions = tracks[track] or= {}
    d3.selectAll(".stat text").each (d,i) ->
      x = d3.select this
      x.text ""
      positions[encode nodes[i].value.label] = x

  stopped: (type, name) ->
    @log.write "recd stopped signal for #{type} #{name}"


  dataReady: (at, text) ->
 #   @log.write "#{at} signal: #{JSON.stringify(text)}"

  stopServer: (event) -> alert "please set action for Controller.stopServer"

  tracks = {}

  format = (number) ->
    switch
      when number >= 1000000000
        "#{(number / 1000000000).toFixed(2)}B"
      when number >= 1000000
        "#{(number / 1000000).toFixed(2)}M"
      when number >= 1000
        "#{(number / 1000).toFixed(1)}K"
      else
        number


