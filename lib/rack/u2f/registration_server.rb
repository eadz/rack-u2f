require 'u2f'
require 'mustache'

module Rack
  module U2f
    # Middleware allow registration of u2f devices
    class RegistrationServer
      include Helpers

      def initialize(config)
        @config = config
        @store = config[:store]
        @registration_enabled = config[:enable_registration]
        raise 'Missing RegistrationMiddleware Config' if @config.nil?
      end

      def call(env)
        return registration_disabled unless @registration_enabled
        request = Rack::Request.new(env)
        if request.get?
          generate_registration(request)
        else
          store_registration(request)
        end
      end

      private

      def registration_disabled
        Rack::Response.new('Registration Disabled', 403)
      end

      def store_registration(request)
        u2f = U2F::U2F.new(extract_app_id(request))
        response = U2F::RegisterResponse.load_from_json(request.params['response'])
        u2f.register!(request.session['challenges'], response)
        @store.store_registration(
          certificate: reg.certificate, key_handle: reg.key_handle,
          public_key: reg.public_key, counter: reg.counter
        )
        Rack::Response.new('Registration Successful')
      rescue U2F::Error
        return Rack::Response.new('Unable to register device', 422)
      ensure
        request.session.delete('challenges')
      end

      def generate_registration(request)
        u2f = U2F::U2F.new('https://junk.ngrok.io')
        registration_requests = u2f.registration_requests
        request.session['challenges'] = registration_requests.map(&:challenge)
        key_handles = @store.key_handles
        sign_requests = u2f.authentication_requests(key_handles)

        registration_page(u2f.app_id, registration_requests, sign_requests)
      end

      def registration_page(app_id, registration_requests, sign_requests)
        content = Mustache.render(
          REGISTRATION_TEMPLATE,
          app_id: app_id.to_json,
          registration_requests: registration_requests.to_json,
          sign_requests: sign_requests.to_json,
          u2fjs: U2FJS
        )
        Rack::Response.new(content)
      end
    end
  end
end
