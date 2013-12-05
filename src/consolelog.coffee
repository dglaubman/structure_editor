root = exports ? window

# Set up a LIFO log
class root.Log
  constructor: (@targ) ->
    @lines = 0

  write: (message) ->
    if @lines++  > Log.MaxLines then @clear()
    @targ.append("pre").text "#{message}"

  clear: () ->
    @targ.html ''
    @lines = 0

  Log.MaxLines = 500
