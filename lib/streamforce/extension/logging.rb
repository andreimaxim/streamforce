class Streamforce::Extension::Logging
  def initialize(log_level = Logger::DEBUG)
    @logger = Logger.new($stdout)
    @logger.level = log_level
  end

  def incoming(message, callback)
    @logger.debug "Receving message: #{message.inspect}"

    callback.call(message)
  end

  def outgoing(message, callback)
    @logger.debug "Sending message: #{message.inspect}"

    callback.call(message)
  end
end
