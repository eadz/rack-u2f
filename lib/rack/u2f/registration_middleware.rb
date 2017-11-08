module Rack
  module U2f
    class RegistrationMiddleware

      def initialize(app)
        @app = app
      end

      def call(env)
        @app.call(env)
      end
      
    end
  end
end
