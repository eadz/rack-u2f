require "spec_helper"

RSpec.describe Rack::U2f::RegistrationMiddleware do
  it "checks for a SECRET ENV" do
    expect(Rack::U2f::VERSION).not_to be nil
  end

  it "returns a 200 code" do
    it "should return a 200 code" do
      response = server.get('/')
      response.status.should == 200
    end
  end
end
