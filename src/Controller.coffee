root = exports ? window

class root.Controller

  log = comm = leaves = undefined

  constructor: (console) ->
    log = console

  start: (callback) =>
    getTicket (ticket) =>
      comm = new Communicator( log, messageHandler this)
      comm.connect config, ticket, callback

  subscribe: (graph) ->
    comm.startSubscription graph

  stat: (track, position, loss) ->
    log.log "#{position}: #{loss}"
    return log.write "error: stat expected track #{@track}, rec'd #{track}" unless track is @track
    positions[position]?.text format loss

  ready: (route, track) ->
    log.write "#{route} on #{track}"
    nodes = graph().nodes
    leaves = graph().initial
    positions = tracks[track] or= {}
    d3.selectAll(".stat text").each (d,i) ->
      x = d3.select this
      key = nodes[i].value.label
      initial = leaves[key] or  ""  # initial value
      x.text format initial
      positions[encode key] = x
    @track = track

  run: (numIter) ->
    d3.entries( leaves )
      .forEach (entry) ->
        comm.startFeed entry.key, @track, entry.Value, numIter

  stopped: (type, name) ->
    log.write "recd stopped signal for #{type} #{name}"

  tracks = {}
  positions = undefined
  leaves = undefined

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

messageHandler = (controller) -> (m) ->
  topic = m.args.routingKey
  body = m.body.getString(Charset.UTF8)
  switch m.args.exchange
    when config.serverX
      serverDispatcher controller, body

getTicket = (callback) ->
  d3.text './ts', (err, ticket) ->
    if err
      log.write err
    else
      callback ticket
