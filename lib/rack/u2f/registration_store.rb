require 'rack/u2f/registration_store/active_record_store'
require 'rack/u2f/registration_store/redis_store'

module Rack
  module U2f
    # Store to keep track of tokens
    module RegistrationStore
      # class AbstractStore
      #   def initialize(*args)
      #   end
      #
      #   def store_registration(certificate:, key_handle:, public_key:, counter:)
      #   end
      #
      #   def update_registration(key_handle:, counter:)
      #   end
      #
      #   def key_handles
      #   end
      # end
    end
  end
end
