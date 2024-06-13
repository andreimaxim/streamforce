class Streamforce::Client
  class << self
    def host
      ENV["SALESFORCE_HOST"]
    end

    def client_id
      ENV["SALESFORCE_CLIENT_ID"]
    end

    def client_secret
      ENV["SALESFORCE_CLIENT_SECRET"]
    end

    def username
      ENV["SALESFORCE_USERNAME"]
    end

    def password
      ENV["SALESFORCE_PASSWORD"]
    end

    def security_token
      ENV["SALESFORCE_SECURITY_TOKEN"]
    end

    def version
      ENV.fetch("SALESFORCE_API_VERSION", "61.0")
    end

    def authentication_url
      URI.parse("https://#{host}/services/oauth2/token")
    end

    def authentication_params
      {
        grant_type: "password",
        client_id: client_id,
        client_secret: client_secret,
        username: username,
        password: "#{password}#{security_token}"
      }
    end
  end

  def set_authentication_credentials!
    response = Net::HTTP.post_form(Streamforce::Client.authentication_url, Streamforce::Client.authentication_params)
    credentials = JSON.parse(response.body)

    @access_token = credentials["access_token"]
    @instance_url = "#{credentials["instance_url"]}/cometd/#{Streamforce::Client.version}"
  end

  def subscribe(channels = [], &blk)
    channels = Array(channels)

    set_authentication_credentials!

    EM.run { subscribe_to_channels(faye, channels, &blk) }
  end

  def faye
    @faye ||= Faye::Client.new(@instance_url).tap do |client|
      client.set_header "Authorization", "OAuth #{@access_token}"

      client.add_extension Streamforce::Extension::Replay.new
      client.add_extension Streamforce::Extension::SubscriptionTracking.new
      client.add_extension Streamforce::Extension::Logging.new
    end
  end

  def subscribe_to_channels(client, channels, &blk)
    return if channels.empty?

    client
      .subscribe(channels.shift, &blk)
      .callback { subscribe_to_channels(client, channels, &blk) }
  end
end
