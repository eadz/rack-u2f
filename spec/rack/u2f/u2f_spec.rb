require 'spec_helper'

RSpec.describe Rack::U2f do
  it 'has a version number' do
    expect(Rack::U2f::VERSION).not_to be nil
  end
end
