class Streamforce::Client
  attr_reader :host, :username, :password, :client_id, :client_secret, :security_token,
    :api_version

  def initialize(opts = {})
    @host           = opts.fetch(:host, ENV["SALESFORCE_HOST"])
    @username       = opts.fetch(:username, ENV["SALESFORCE_USERNAME"])
    @password       = opts.fetch(:password, ENV["SALESFORCE_PASSWORD"])
    @client_id      = opts.fetch(:client_id, ENV["SALESFORCE_CLIENT_ID"])
    @client_secret  = opts.fetch(:client_secret, ENV["SALESFORCE_CLIENT_SECRET"])
    @security_token = opts.fetch(:security_token, ENV["SALESFORCE_SECURITY_TOKEN"])
    @api_version    = opts.fetch(:api_version, ENV["SALESFORCE_API_VERSION"])

    @logger = opts.fetch(:logger, Logger.new($stdout))
  end

  def subscribe(channels = [], &blk)
    EM.run { subscribe_to_channels(faye, Array(channels), &blk) }
  end

  private

  def instance_url
    authentication["instance_url"]
  end

  def access_token
    authentication["access_token"]
  end

  def authentication_url
    URI.parse("https://#{host}/services/oauth2/token")
  end

  def authentication_params
    {
      grant_type: "password",
      username: username,
      password: "#{password}#{security_token}",
      client_id: client_id,
      client_secret: client_secret
    }
  end

  def authentication
    @authentication ||= fetch_authentication_credentials
  end

  def fetch_authentication_credentials
    response = Net::HTTP.post_form(authentication_url, authentication_params)
    JSON.parse(response.body)
  end

  def faye
    @faye ||= Faye::Client.new("#{instance_url}/cometd/#{api_version}").tap do |client|
      client.set_header "Authorization", "OAuth #{access_token}"

      client.add_extension Streamforce::Extension::Replay.new
      client.add_extension Streamforce::Extension::Logging.new(@logger)
    end
  end

  def subscribe_to_channels(client, channels, &blk)
    return if channels.empty?

    # Subscribe to a single channel, otherwise Salesforce will return a 403 Unknown Client error
    subscription = client.subscribe(channels.shift)

    # Allow clients to receive [ channel, message ] block params
    subscription.with_channel(&blk)

    # Continue subscribing to the rest of the channels, regadless of the current subscription
    # status
    subscription
      .callback { subscribe_to_channels(client, channels, &blk) }
      .errback { subscribe_to_channels(client, channels, &blk) }
  end
end
