# Rack::U2f

Rack middleware to require add u2f authentication.

Note: This gem needs a tidy up and will be properly released by end of Nov 2017

[![Gem Version](https://badge.fury.io/rb/rack-u2f.svg)](https://badge.fury.io/rb/rack-u2f)
[![Build Status](https://api.travis-ci.org/eadz/rack-u2f.svg?branch=master)](https://travis-ci.org/eadz/rack-u2f)

Note: U2F only works on *https* connections.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-u2f'
```

And then execute:

    $ bundle

## Usage

Rack U2F has two components; A Rack app to register U2F devices and Rack Middleware to authenticate against registered U2F devices. When registration is enabled, you can add a u2f device through the `u2f_register_path`.

For U2F to work, persistence of a counter is required, therefore a storage mechanism is needed. Right now, this gem supports [Redis](https://redis.io), and ActiveRecord. There is a simple API to add more stores as required.

## Config

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

## Store Config

### Redis Store

The `Rack::U2f::RegistrationStore::RedisStore.new` by default uses `Redis.new` as the redis connection.
You can pass in your own connection as the single argument to `RedisStore.new()`, for example:

```ruby
store: Rack::U2f::RegistrationStore::RedisStore.new(Redis.new(url: 'redis://10.1.1.1/'))
```

### ActiveRecord Store

Use `Rack::U2f::RegistrationStore::ActiveRecordStore.new(ArModel)`. The `ArModel` should be an active record model with the following schema;

```
t.string :key_handle, index: true
t.text :certificate
t.text :public_key
t.integer :counter
```

## Other Config

### enable_registration

If `enable_registration` is true then you will be able to visit `/_u2f_register` to register a new key.
Registration should not be enabled in production. It is possible to mount the registration server separately as it is a rack app.

When authenticated, the session is used for further authentication. *You must be using a secure session store*.

### after_sign_in_url

The url to be directed to after successful sign in, default: `"/"`

### exclude_urls

An array of regular expressions to match on the path to exclude urls from the u2f requirement.
Be careful here; generally prefixes is the safest way `%r{\A/myprefix}`. Keep in mind that people can add things to paths that may cause an otherwise excluded url to match.

## Development

There is a demo app in the DemoApp folder. Integration tests will require a fake/software u2f key, and is on the TODO list.

## Future Plans

Right now this gem is designed for Admin access to certian parts of the site. In the future, a concept of identity will be added so that you can use it for end users. 

An example might be sending a header in a response from a rails controller "X-REQUIRE-U2F: true", which the middleware would pick up. Passing "X-U2F-IDENTITY: #{user_id}" would allow the middleware to handle per-user u2f tokens. 

This would replace the current path matching in the middleware. 

## See also

The [ruby-u2f](https://github.com/castle/ruby-u2f) gem, which this gem depends on.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eadz/rack-u2f

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Todo ( contributions welcome )
Integration tests using a fake token such as the [soft token helper from google]( https://github.com/google/u2f-ref-code/blob/master/u2f-chrome-extension/softtokenhelper.js)
