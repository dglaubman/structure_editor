class Communicator

  constructor: (@log, @onmessage = @onMessageDefault) ->
    @amqp = new AmqpClient()
    @amqp.addEventListener "close", =>
      @log.write "DISCONNECTED"
    @amqp.addEventListener "error", (e) =>
      @log.write "error: #{e.message}"

  connect: ( @config, @serverTopic = "#", @onconnected) ->
    @amqp.connect {url: config.url, virtualHost: config.virtualhost, credentials: config.credentials} , (evt) =>
        @log.write "CONNECTED"
        @channelsReady = 0
        @publishChannel = @amqp.openChannel @publishChannelOpenHandler
        @serverChannel = @amqp.openChannel @serverChannelOpenHandler

  disconnect: =>
    @amqp.disconnect()

  publish:  ( exchange, text, routingKey ) =>
    body = new ByteBuffer()
    body.putString text, Charset.UTF8
    body.flip()
    headers = {}
    @publishChannel.publishBasic {body: body, exchange: exchange, routingKey: routingKey}


  # deprecated
  sling: (signal, test, track) =>
    @publish @config.workX, "start sling #{signal} #{test} #{track}", @config.execQ

  stopServer: (pid) =>
    @publish @config.workX, "stop #{pid}", @config.execQ

  startSubscription: (name, cmds) =>
    @publish @config.workX, "#{@serverTopic} inline start subscription #{name} #{serialize cmds}", @config.execQ

  startFeed: (name, track, maxLoss, numIter, sequence) =>
    @publish @config.workX, "#{sequence} #{track} start feed #{name} #{maxLoss} #{numIter}", @config.execQ

  flow: ( onOff ) =>
    @serverChannel.flowChannel onOff

  errorHandler: (evt) =>
    @log.write "Error: " + evt.type

  onMessageDefault: (msg) =>
    @log.write "#{msg.args.routingKey}> #{msg.body.getString( Charset.UTF8 )}"

  channelOpenHandler: (channel, exchange, type, label) =>
    @log.log "open '#{exchange}' channel ok"
    channel.declareExchange exchange, type, false, false, false
    channel.addEventListener "declareexchange", =>
      @log.log "declare '#{exchange}' exchange ok"
    channel.addEventListener "close", =>
      @log.log "close '#{exchange}' channel ok"
    @channelsReady++
    @doBind()  if @channelsReady is 2

  publishChannelOpenHandler: (evt) =>
    @channelOpenHandler @publishChannel, @config.workX, 'direct'

  serverChannelOpenHandler: (evt) =>
    @channelOpenHandler @serverChannel, @config.serverX, 'topic'

  listen: (channel, event, label) =>
    channel.addEventListener event, =>
      @log.log "#{event} for '#{label}' ok"

  doBind: =>

    @serverChannel.onmessage = @onmessage
    sQName = "serverQ#{new Date().getTime()}"

    passive = durable = autoDelete = noWait = exclusive = noLocal = noAck = true
    qArgs = null
    tag = ""

    @serverChannel.declareQueue(sQName, not passive, not durable, exclusive, autoDelete, not noWait)
      .bindQueue(sQName, @config.serverX, @serverTopic, not noWait)
      .consumeBasic sQName, tag, not noLocal, noAck, noWait, not exclusive
    @onconnected?()


root = exports ? window
root.Communicator = Communicator

