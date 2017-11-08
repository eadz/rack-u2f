require 'rack'

class DummyServer
  def call(_)
    [200, {}, ['Hello World']]
  end
end
