class Model

  constructor: ->

  cmds: ->

  graph: -> _graph

  text: -> _text

  update: (text) ->
    [g, c] = compile text

m = new Model()
console.log m.name()

m.set 'hi'
console.log m.name()

root = exports ? window
root.Model = Model

