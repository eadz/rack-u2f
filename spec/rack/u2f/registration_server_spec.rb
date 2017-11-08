require 'spec_helper'
require 'fakeredis/rspec'

RSpec.describe Rack::U2f::RegistrationServer do
  let(:default_config) { { store: Rack::U2f::RegistrationStore::RedisStore.new } }
  let(:app) { described_class.new(config) }
  let(:request) { Rack::MockRequest.new(app) }

  describe 'GET' do
    context 'registration enabled' do
      let(:config) { default_config.merge(enable_registration: true) }
      it 'should return a 200 status' do
        response = request.get('/')
        expect(response.status).to eq(200)
      end
    end

    context 'registration not enabled' do
      let(:config) { default_config }
      it 'should return a 403 status' do
        response = request.get('/')
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'POST' do
    context 'registration not enabled' do
      let(:config) { default_config }
      it 'should return a 403 status' do
        response = request.post('/')
        expect(response.status).to eq(403)
      end
    end
  end
end
