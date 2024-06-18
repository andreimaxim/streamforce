# Streamforce

In most cases, consuming events received from the Salesforce Streaming API can be
broken down into three very specific steps:

1. Connecting to the Salesforce API and listening for messages
2. Ingesting received messages into some sort of internal event bus (e.g. RabbitMQ,
   Kafka, Redis, etc)
3. Processing the stored messages

Streamforce aims to be an abstraction for the first step, by implementing some of the
common tasks that need to be performed by any well-behaved client:

* The interactions with the Streaming API need to be logged using the correct severity
  (e.g. handshakes should use `Logger::DEBUG` while subscription errors should use
  `Logger::ERROR` for better visibility)
* Replay IDs need to be stored using a persistent storage like Redis and not in-memory

As an alternative, checkout [Restforce](https://github.com/restforce/restforce).

## Usage

A very simple client, which automatically connects based on the following environment
variables:

* `SALESFORCE_USERNAME`
* `SALESFORCE_PASSWORD`
* `SALESFORCE_SECURITY_TOKEN`
* `SALESFORCE_CLIENT_ID`
* `SALESFORCE_CLIENT_SECRET`
* `REDIS_URL`

```ruby
require "streamforce"

client = Streamforce::Client.new

subscriptions = %w[
  /topic/account-monitor
  /event/AccountUpdated__e
]

client.subscribe(subscriptions) do |subscription, message|
  # Your code
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/andreimaxim/streamforce>.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
