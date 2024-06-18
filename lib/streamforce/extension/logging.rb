class Streamforce::Extension::Logging
  def initialize(logger)
    @logger = logger
  end

  def incoming(payload, callback)
    message = Streamforce::Message.new(payload)

    case message.channel
    when "/meta/handshake"
      log_incoming_handshake(message)
    when "/meta/connect"
      log_incoming_connect(message)
    when "/meta/subscribe"
      log_incoming_subscribe(message)
    else
      @logger.debug "[#{message.channel}] #{message.data}"
    end

    callback.call(payload)
  end

  def outgoing(payload, callback)
    message = Streamforce::Message.new(payload)

    case message.channel
    when "/meta/handshake"
      @logger.debug "[Client] Handshake requested..."
    when "/meta/connect"
      debug message, "Sending connection request"
    when "/meta/subscribe"
      log_outgoing_subscribe(message)
    else
      @logger.debug "[#{message.channel}] #{message.data}"
    end

    callback.call(payload)
  end

  def log_incoming_handshake(message)
    if message.success?
      @logger.debug "[Server] Handshake accepted, assigning client_id=#{message.client_id}"
    else
      @logger.error "[Server] Connection was refused: #{message.error_message}"
    end
  end

  def log_incoming_connect(message)
    if message.success?
      debug message, "Connection successful!"
    else
      error message, "Connection failed: #{message.error_message}"
    end
  end

  def log_outgoing_subscribe(message)
    replay_id = message.replay_id

    replay_info = if message.no_replay?
      "for all new messages"
    elsif message.replay_available_messages?
      "and requesting all stored messages"
    else
      "and requesting all messages newer than ##{replay_id}"
    end

    info message, "Subscribing to #{message.subscription} #{replay_info}"
  end

  def log_incoming_subscribe(message)
    if message.success?
      info message, "Successfully subscribed to #{message.subscription}"
    else
      error message, "Subscription for #{message.subscription} failed: #{message.error_message}"
    end
  end

  def debug(message, text)
    @logger.debug "[#{message.client_id}##{message.id}] #{text}"
  end

  def info(message, text)
    @logger.info "[#{message.client_id}##{message.id}] #{text}"
  end

  def warn(message, text)
    @logger.warn "[#{message.client_id}##{message.id}] #{text}"
  end

  def error(message, text)
    @logger.error "[#{message.client_id}##{message.id}] #{text}"
  end
end
