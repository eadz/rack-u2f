require 'spec_helper'
require 'fakeredis/rspec'

RSpec.describe Rack::U2f::RegistrationServer do
  let(:config) { {store: Rack::U2f::RegistrationStore::RedisStore.new } }
  let(:app) { described_class.new(config) }
  let(:request) { Rack::MockRequest.new(app) }

  context 'registration enabled' do
    before do
      ENV['ENABLE_U2F_REGISTRATION'] = 'true'
    end
    it 'should return a 200 status' do
      response = request.get('/')
      expect(response.status).to eq(200)
    end
  end

  context 'registration not enabled' do
    before do
      ENV['ENABLE_U2F_REGISTRATION'] = nil
    end
    it 'should return a 403 status' do
      response = request.get('/')
      expect(response.status).to eq(403)
    end
  end
end
