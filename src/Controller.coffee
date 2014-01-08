root = exports ? window

class root.Controller

  log = comm = leaves = positions = id = undefined

  constructor: (console) ->
    log = console

  start: (callback) =>
    getTicket (ticket) =>
      comm = new Communicator( log, messageHandler this)
      comm.connect config, ticket, callback

  subscribe: (graph) ->
    comm.startSubscription graph

  stat: (track, position, losses) ->
    return log.write "error: stat expected track #{@track}, rec'd #{track}" unless track is @track
    if losses.length > 0
      [x,num] =  positions[position] or [{text: -> 0}, 0]
      num +=  losses.length
      log.log "#{position}: #{num}"
#      losses.forEach x.observe
      x.text format losses[losses.length - 1]
      positions[position] = [x,num]

  ready: (route, track) ->
    log.write "#{route} on #{track}"
    nodes = graph().nodes
    leaves = graph().initial
    positions = {}
    d3.selectAll(".stat text").each (d,i) ->
      x = d3.select this
      key = nodes[i].value.key
      initial = leaves[key] or  ""  # initial value
      x.text format initial
      positions[encode key] = [x,0]
    @track = track

  run: (numIter) ->
    sequence = Date.now()
    d3.entries( leaves )
      .forEach (entry) =>
        comm.startFeed "Start_#{encode entry.key}", @track, entry.value, numIter, sequence

  stopped: (type, name) ->
    log.write "recd stopped signal for #{type} #{name}"

  leaves = undefined

  format = (number) ->
    switch
      when number >= 1000000000
        "#{(number / 1000000000).toFixed(2)}B"
      when number >= 1000000
        "#{(number / 1000000).toFixed(2)}M"
      when number >= 1000
        "#{(number / 1000).toFixed(1)}K"
      when number is ""
        ""
      when number < 1
        "0"
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
