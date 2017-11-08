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
        raise 'Missing RegistrationMiddleware Config' if @config.nil?
      end

      def call(env)
        return [403, {}, ['Registration Disabled']] unless @config[:enable_registration]
        request = Rack::Request.new(env)
        if request.get?
          generate_registration(request)
        else
          u2f = U2F::U2F.new(extract_app_id(request))

          response = U2F::RegisterResponse.load_from_json(request.params['response'])
          reg = begin
            u2f.register!(request.session['challenges'], response)
          rescue U2F::Error => e
            return [422, {}, ['Unable to register device']]
          ensure
            request.session.delete('challenges')
          end
          @store.store_registration(
            certificate: reg.certificate,
            key_handle: reg.key_handle,
            public_key: reg.public_key,
            counter: reg.counter
          )
          return [200, {}, ["Registration Successful"]]
        end
      end

      private

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
