# Rack::U2f

Note: This gem needs a tidy up and will be properly released by end of Nov 2017

[![Gem Version](https://badge.fury.io/rb/rack-u2f.svg)](https://badge.fury.io/rb/rack-u2f)

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

in `config/application.rb`

```ruby
config.middleware.use Rack::U2f::AuthenticationMiddleware, {
  store: Rack::U2f::RegistrationStore::RedisStore.new,
  exclude_urls: [/\Au2f/, /\A\/\z/],
  enable_registration: ENV['ENABLE_U2F_REGISTRATION'] == "true",
  after_sign_in_url: '/', # optional, defaults to '/'
  u2f_register_path: '/_u2f_register' #optional, defaults to '/_u2f_register'
}
```

Currently only a redis store is developed, but other stores such as active record will be easy to add.

if `enable_registration` is set to `"true"` then you will be able to visit `/_u2f_register` to register a new key.

Note: U2F only works on *https* connections.

In addition, the registration depends on the url used to register, so data from one environment will not work on another.

When authenticated, the session is used to store that fact. *You must be using a secure session store*.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eadz/rack-u2f.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
