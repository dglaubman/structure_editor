root = exports ? window
root.every = (ms, func) ->
  if ms < Infinity
    func()
    setInterval func, ms
