require 'fakeredis/rspec'

RSpec.describe Rack::U2f::RegistrationStore::RedisStore do
  include_examples 'a valid u2f store implimentation', described_class.new
end
