# Rack::U2f

Note: This gem needs a tidy up and will be properly released by end of Nov 2017

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-u2f'
```

And then execute:

    $ bundle

## Usage

Rack U2F has two components;

A Rack app to register U2F devices

and

Rack middleware to authenticate against registered U2F devices

In rails:

In `config/routes.rb`:

```ruby
mount Rack::U2f::RegistrationServer.new(store: Rack::U2f::RegistrationStore::RedisStore.new), at: '/u2f_registration'
```

in `config/application.rb`

```ruby
config.middleware.use Rack::U2f::AuthenticationMiddleware, {
  store: Rack::U2f::RegistrationStore::RedisStore.new,
  exclude_urls: [/\Au2f/, /\A\/\z/]
}
```

Currently only a redis store is developed, but other stores such as active record will be easy to add.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eadz/rack-u2f.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).