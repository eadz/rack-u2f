module Rack
  module U2f
    # Store to keep track of u2f data in active record (WIP)
    module RegistrationStore
      class ActiveRecordStore
        def initialize(ar_model)
          @model = ar_model
        end

        def store_registration(certificate:, key_handle:, public_key:, counter:)
        end

        def get_registration(key_handle:)
        end

        def update_registration(key_handle:, counter:)
        end

        def key_handles
        end
      end
    end
  end
end
