require 'redis'
module Rack
  module U2f
    # Store to keep track of u2f data in redis
    module RegistrationStore
      class RedisStore
        def initialize(redis_connection = nil)
          @redis = redis_connection || Redis.new
          @hash_key_prefix = 'rack-u2f'
        end

        def store_registration(certificate:, key_handle:, public_key:, counter:)
          @redis.hset(
            @hash_key_prefix,
            key_handle,
            JSON.dump(
              certificate: certificate,
              public_key: public_key,
              counter: counter
            )
          )
        end

        def get_registration(key_handle:)
          data = @redis.hget(@hash_key_prefix, key_handle)
          data && JSON.parse(data)
        end

        def update_registration(key_handle:, counter:)
          existing = get_registration(key_handle: key_handle)
          if existing
            @redis.hset(
              @hash_key_prefix,
              key_handle,
              JSON.dump(
                certificate: existing['certificate'],
                public_key: existing['public_key'],
                counter: counter
              )
            )
          end
        end

        def key_handles
          @redis.hkeys(@hash_key_prefix) || []
        end
      end
    end
  end
end
