root = exports ? window

# Set up a LIFO log
class root.Log
  constructor: (@targ) ->
    @lines = 0

  write: (message) ->
    if @lines++  > Log.MaxLines then @clear()
    @targ.prepend( "<pre>#{message}</pre>" )

  clear: () ->
    @targ.html ''
    @lines = 0

  Log.MaxLines = 500