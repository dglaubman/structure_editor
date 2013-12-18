class Communicator

  constructor: (@log, @onmessage = @onMessageDefault, @serverTopic = "#") ->
    @amqp = new AmqpClient()
    @amqp.addEventListener "close", =>
      @log.write "DISCONNECTED"
    @amqp.addEventListener "error", (e) =>
      @log.write "error: #{e.message}"

  connect: ( @config, credentials, @onconnected) ->
    @amqp.connect {url: config.url, virtualHost: config.virtualhost, credentials: credentials} , (evt) =>
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


  sling: (signal, test, track) =>
    @publish @config.workX, "start sling #{signal} #{test} #{track}", @config.execQ

  stopServer: (pid) =>
    @publish @config.workX, "stop #{pid}", @config.execQ

  startSubscription: (name, uid) =>
    @publish @config.workX, "#{uid} unused start subscription #{name}", @config.execQ

  flow: ( onOff ) =>
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
    @doBind()  if @channelsReady is 2

  publishChannelOpenHandler: (evt) =>
    @channelOpenHandler @publishChannel, @config.workX, 'direct'

  serverChannelOpenHandler: (evt) =>
    @channelOpenHandler @serverChannel, @config.serverX, 'topic'

  listen: (channel, event, label) =>
    channel.addEventListener event, =>
      @log.write "#{event} for '#{label}' ok"

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

