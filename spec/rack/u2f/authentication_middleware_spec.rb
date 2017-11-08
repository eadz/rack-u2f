require 'spec_helper'
require 'fakeredis/rspec'

RSpec.describe Rack::U2f::AuthenticationMiddleware do
  let(:store) { Rack::U2f::RegistrationStore::RedisStore.new }
  let(:default_config) { { store: store} }
  let(:fallback_app) { ->(_env) { [200, {}, ['Hello World']] } }
  let(:app) { described_class.new(fallback_app, default_config) }
  let(:request) { Rack::MockRequest.new(app) }

  describe 'u2f authentication' do
    context 'when there are no registered devices' do
      it 'returns a no registered devices error' do
        response = request.get('/')
        expect(response.status).to eq(403)
        expect(response.body).to include('Unregistered Device')
      end
    end

    context 'when there is one registered device' do
      before do
        default_config[:store].store_registration(certificate: 'x', key_handle: 'x', public_key: 'x', counter: 1)
      end
      it 'returns an authentication page' do
        response = request.get('/')
        expect(response.status).to eq(403)
        expect(response.body).to include('<title>U2F Challenge</title>')
      end
    end

    context 'when the url is excluded' do
      let(:default_config) { { store: store, exclude_urls: [/\A\//] } }
      it 'passes through the request' do
        response = request.get('/')
        expect(response.status).to eq(200)
        expect(response.body).to eq('Hello World')
      end
    end
  end

  describe 'u2f registration passthrough' do

    context 'registration disabled' do
      let(:default_config) { { store: store } }
      it 'calls the registration server on the default url' do
        response = request.get('/_u2f_register')
        expect(response.status).to eq(403)
        expect(response.body).to include("Registration Disabled")
      end
    end

    context 'registration enabled' do
      context 'default registration path' do
        let(:default_config) { { store: store, enable_registration: true } }
        it 'calls the registration server on the default url' do
          response = request.get('/_u2f_register')
          expect(response.status).to eq(200)
          expect(response.body).to include("<title>U2F Registration</title>")
        end
      end

      context 'custom registration path' do
        let(:default_config) { { store: store, enable_registration: true, u2f_register_path: '/path2' } }

        it 'calls the registration server on the custom path' do
          response = request.get('/path2')
          expect(response.status).to eq(200)
          expect(response.body).to include("<title>U2F Registration</title>")
        end

      end
    end
  end
end
