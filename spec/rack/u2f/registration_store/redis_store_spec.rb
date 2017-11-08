require 'fakeredis/rspec'

RSpec.describe Rack::U2f::RegistrationStore::RedisStore do
  include_examples 'a valid u2f store implimentation', described_class.new

  it 'allows a custom redis connection to be passed in' do
    custom_redis = Redis.new
    redis_store = described_class.new(custom_redis)
    expect(custom_redis).to receive(:hkeys)
    redis_store.key_handles
  end
end
