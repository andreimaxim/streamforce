class Streamforce::Extension::Replay
  def initialize(log_level = Logger::INFO)
    @logger = Logger.new($stdout)
    @logger.level = log_level
  end

  def incoming(message, callback)
    callback.call(message)
  end

  def outgoing(message, callback)
    callback.call(message)
  end
end
