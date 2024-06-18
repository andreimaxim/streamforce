class Streamforce::Message
  def initialize(payload)
    @payload = payload
  end

  def client_id
    @payload["clientId"]
  end

  def id
    @payload["id"]
  end

  def replay_id
    @payload.dig "ext", "replay", subscription
  end

  def channel
    @payload["channel"]
  end

  def channel_type
    channel.split("/")[1]
  end

  def channel_name
    channel.split("/")[2]
  end

  def success?
    @payload["successful"]
  end

  def data
    @payload["data"]
  end

  def subscription
    @payload["subscription"]
  end

  def subscription?
    channel == "/meta/subscribe"
  end

  def replay_from_message?
    replay_id && replay_id != -1 && replay_id != -2
  end

  def replay_available_messages?
    replay_id == -2
  end

  def no_replay?
    replay_id.nil? || replay_id == -1
  end

  def error_message
    @payload["error"]
  end
end
