module Rack
  module U2f
    # Middleware to authenticate against registered u2f keys
    class AuthenticationMiddleware
      include Helpers

      def initialize(app, config = nil)
        @app = app
        @store = config[:store] || raise('Please specify a U2F store such as Rack::U2f::RegistrationStore::RedisStore.new')
        @exclude_urls = config[:exclude_urls] || [/\A\/u2f/]
      end

      def call(env)
        request = Rack::Request.new(env)
        return @app.call(env) if excluded?(request)
        return @app.call(env) if authenticated?(request)
        return resp_auth_from_u2f(request) if request.params['u2f_auth']
        challenge_page(request)
      end

      private

      def excluded?(request)
        @exclude_urls.any?{ |exc| request.path =~ exc }
      end

      def authenticated?(request)
        request.session['u2f_authenticated']
      end

      def resp_unregistered
        [403, {}, ["Unregistered Device"]]
      end

      def resp_invalid
        [403, {}, ["Invalid Auth"]]
      end

      def resp_auth_from_u2f(request)
        u2f_response = U2F::SignResponse.load_from_json(request.params['u2f_auth'])
        registration = @store.get_registration(key_handle: u2f_response.key_handle)
        return unregistered unless registration
        begin
          u2f = U2F::U2F.new(extract_app_id(request))
          u2f.authenticate!(request.session['challenge'], u2f_response,
                    Base64.decode64(registration['public_key']),
                    registration['counter'])
        rescue U2F::Error => e
          return resp_invalid
        ensure
          request.session.delete('challenge')
        end

        @store.update_registration(key_handle: u2f_response.key_handle, counter: u2f_response.counter)
        request.session['u2f_authenticated'] = true
        [302, {"Location" => '/'}, []]
      end

      def challenge_page(request)
        key_handles = @store.key_handles
        return resp_unregistered unless key_handles && key_handles.size > 0
        u2f = U2F::U2F.new(extract_app_id(request))
        sign_requests = u2f.authentication_requests(key_handles)
        challenge = u2f.challenge
        request.session['challenge'] = challenge

        content = Mustache.render(
          CHALLENGE_TEMPLATE,
          app_id: u2f.app_id.to_json,
          challenge: challenge.to_json,
          sign_requests: sign_requests.to_json,
          u2fjs: U2FJS
        )

        Rack::Response.new(content)
      end
    end
  end
end
