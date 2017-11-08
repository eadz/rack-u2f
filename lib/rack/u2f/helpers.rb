module Rack
  module U2f
    # Helpers used in the middleware and registration server
    module Helpers
      def extract_app_id(request)
        app_id = request.url.split('/')[0..2].join('/')
        return app_id if [443, 80].include?(request.port)
        app_id + ':' + request.port
      end
    end
  end
end
