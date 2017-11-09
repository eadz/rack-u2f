module Rack
  module U2f
    # Store to keep track of u2f data in active record (WIP)
    module RegistrationStore
      class ActiveRecordStore
        def initialize(ar_model)
          @model = ar_model
        end

        def store_registration(certificate:, key_handle:, public_key:, counter:)
          @model.create!(
            certificate: certificate,
            key_handle: key_handle,
            public_key: public_key,
            counter: counter
          )
        end

        def get_registration(key_handle:)
          key = @model.where(key_handle: key_handle).first
          key && key.as_json.slice('certificate', 'public_key', 'counter')
        end

        def update_registration(key_handle:, counter:)
          @model.where(key_handle: key_handle).update_all(counter: counter)
        end

        def key_handles
          @model.pluck(:key_handle)
        end
      end
    end
  end
end
