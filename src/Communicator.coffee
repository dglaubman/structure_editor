class Communicator

  semver: "0.1.1"

  constructor: (@log, @onmessage = @onMessageDefault) ->
    @amqp = new AmqpClient()
    @amqp.addEventListener "close", =>
      @log.write "DISCONNECTED"
    @amqp.addEventListener "error", (e) =>
      @log.write "error: #{e.message}"
    @portIndex = 0

  connect: ( @config, credentials, @onconnected) ->
    @amqp.connect {url: config.url, virtualHost: config.virtualhost, credentials: credentials} , (evt) =>
        @log.write "CONNECTED"
        @channelsReady = 0
        @publishChannel = @amqp.openChannel @publishChannelOpenHandler
        @exposureChannel = @amqp.openChannel @exposureChannelOpenHandler
        @serverChannel = @amqp.openChannel @serverChannelOpenHandler

  disconnect: =>
    @amqp.disconnect()

  publish:  ( exchange, text, routingKey ) =>
    body = new ByteBuffer()
    body.putString text, Charset.UTF8
    body.flip()
    headers = {}
    @publishChannel.publishBasic {body: body, exchange: exchange, routingKey: routingKey}


  startEngine: (name) =>
    @publish @config.workX, "start engine #{name}", @config.execQ

  startAdapter: (name) =>
    @publish @config.workX, "start adapter #{name}", @config.execQ

  startTrigger: (name, rak, signals) =>
    @publish @config.workX, "start trigger #{name} #{rak} #{signals}", @config.execQ

  stopServer: (pid) =>
    @publish @config.workX, "stop #{pid}", @config.execQ

  startRak: (msg, signal) =>
    @publish @config.signalX, msg, signal

  flow: ( onOff ) =>
    @exposureChannel.flowChannel onOff
    @serverChannel.flowChannel onOff

  errorHandler: (evt) =>
    @log.write "Error: " + evt.type

  onMessageDefault: (msg) =>
    @log.write "#{msg.args.routingKey}> #{msg.body.getString( Charset.UTF8 )}"

  channelOpenHandler: (channel, exchange, type, label) =>
    @log.write "open '#{exchange}' channel ok"
    channel.declareExchange exchange, type, false, false, false
    channel.addEventListener "declareexchange", =>
      @log.write "declare '#{exchange}' exchange ok"
    channel.addEventListener "close", =>
      @log.write "close '#{exchange}' channel ok"
    @channelsReady++
    @doBind()  if @channelsReady is 3

  publishChannelOpenHandler: (evt) =>
    @channelOpenHandler @publishChannel, @config.workX, 'direct'

  exposureChannelOpenHandler: (evt) =>
    @channelOpenHandler @exposureChannel, @config.signalX, 'topic'

  serverChannelOpenHandler: (evt) =>
    @channelOpenHandler @serverChannel, @config.serverX, 'topic'

  listen: (channel, event, label) =>
    channel.addEventListener event, =>
      @log.write "#{event} for '#{label}' ok"

  doBind: =>

    @exposureChannel.onmessage = @onmessage
    @serverChannel.onmessage = @onmessage
    eQName = "exposureQ#{new Date().getTime()}"
    sQName = "serverQ#{new Date().getTime()}"

    passive = durable = autoDelete = noWait = exclusive = noLocal = noAck = true
    qArgs = null
    tag = ""

    @exposureChannel.declareQueue(eQName, not passive, not durable, exclusive, autoDelete, not noWait)
      .bindQueue(eQName, @config.signalX, "#", not noWait)
      .consumeBasic eQName, tag, not noLocal, noAck, noWait, not exclusive
    @serverChannel.declareQueue(sQName, not passive, not durable, exclusive, autoDelete, not noWait)
      .bindQueue(sQName, @config.serverX, "#", not noWait)
      .consumeBasic sQName, tag, not noLocal, noAck, noWait, not exclusive
    @onconnected?()


root = exports ? window
root.Communicator = Communicator

