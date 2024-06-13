class Streamforce::Extension::SubscriptionTracking
  def initialize(log_level = Logger::DEBUG)
    @logger = Logger.new($stdout)
    @logger.level = log_level

    @subscriptions = []
  end

  def incoming(message, callback)
    if subscription?(message)
      log_subscription_status(message)
    else
      log_subscription_payload(message)
    end

    callback.call(message)
  end

  def outgoing(message, callback)
    @logger.debug "Requested subscription for #{message["subscription"]}" if subscription?(message)

    callback.call(message)
  end

  def log_subscription_status(message)
    subscription = message["subscription"]

    if message["successful"]
      @subscriptions << subscription

      @logger.info "Subscription for #{subscription} was successful"
    else
      @logger.warn "Subscription for #{subscription} failed: #{message["error"]}"
    end
  end

  def log_subscription_payload(message)
    channel = message["channel"]
    payload = message["data"].to_json

    type = case channel.split("/")[1]
    when "topic"
             "PushTopic"
    when "event"
             "PlatformEvent"
    else
             "Unknown"
    end

    name = channel.split("/")[2]

    @logger.info "[#{type}][#{name}]: #{payload}" if @subscriptions.include?(channel)
  end

  def subscription?(message)
    message["channel"] == "/meta/subscribe"
  end
end
