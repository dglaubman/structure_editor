root = exports ? window

root.every = (ms, func) ->
  if ms < Infinity
    func()
    setInterval func, ms

root.encode = (str) ->
  encodeURIComponent str

root.serialize = (o) ->
  encodeURIComponent JSON.stringify o

