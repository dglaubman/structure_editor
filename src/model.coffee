compile = require 'compile'

SENTINEL = 9007199254740992                 # Max int - used for STOPMSG

class Model

  constructor: ->

  cmds: -> @c

  startCmds: ->
    d3.entries( @g.initial ).map (entry) ->
      { key: "Start_#{encode entry.key}", value: entry.value }


  stopCmds: ->
    d3.entries( @g.initial ).map (entry) ->
      { key : "Start_#{encode entry.key}", value: SENTINEL }

  graph: -> @g

  status: -> @s

  update: (text) ->
    {status, graph, cmds} = compile text
    [@s, @g, @c] = [status, graph, cmds]

root = exports ? window
root.Model = Model

