# Streamforce

## Usage

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

Bug reports and pull requests are welcome on GitHub at https://github.com/andreimaxim/streamforce.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
