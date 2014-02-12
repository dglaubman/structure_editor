compile = require 'compile'

class Model

  constructor: ->

  cmds: -> @c

  graph: -> @g

  status: -> @s

  update: (text) ->
    {status, graph, cmds} = compile text
    [@s, @g, @c] = [status, graph, cmds]

root = exports ? window
root.Model = Model

