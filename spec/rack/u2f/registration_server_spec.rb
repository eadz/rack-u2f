require 'spec_helper'

RSpec.describe Rack::U2f::RegistrationServer do
  let(:config) { {} }
  let(:stack) { described_class.new(config) }
  let(:request) { Rack::MockRequest.new(stack) }

  context 'have already registered' do
    let(:config) { { 'U2F_REGISTRATION' => '1234' } }
    it 'should return a 403 code if the U2F secret is already present' do
      response = request.get('/')
      expect(response.status).to eq(403)
    end
  end

  context 'not yet registered' do
    it 'should return a 200 status' do
      response = request.get('/')
      expect(response.status).to eq(200)
    end
  end
end
