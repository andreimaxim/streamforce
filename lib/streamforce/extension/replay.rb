require "redis"

class Streamforce::Extension::Replay
  def initialize(log_level = Logger::INFO)
    @logger = Logger.new($stdout)
    @logger.level = log_level
    @redis = Redis.new
  end

  def incoming(message, callback)
    replay_id = message.dig "data", "event", "replayId"
    channel   = message["channel"]

    store(channel, replay_id)
    callback.call(message)
  end

  def outgoing(message, callback)
    return callback.call(message) unless message["channel"] == "/meta/subscribe"

    channel = message["subscription"]
    message["ext"] = { "replay" => { channel => replay_id(channel).to_i } }

    callback.call(message)
  end

  def store(channel, replay_id)
    return if channel.nil? || replay_id.nil?

    @redis.set channel, replay_id, ex: 86400
  end

  def replay_id(channel)
    @redis.get(channel) || -1
  end
end
