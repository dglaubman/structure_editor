root = exports ? window

# Set up a LIFO log
class root.Log
  constructor: (@targ, @verbose = false) ->
    @lines = 0

  log: (message) ->
    return unless @verbose
    @write message

  write: (message) ->
    if @lines++  > Log.MaxLines then @clear()
    @targ.append("pre").text "#{message}"

  clear: () ->
    @targ.html ''
    @lines = 0

  toggle: () ->
    @verbose = not @verbose

  Log.MaxLines = 500
