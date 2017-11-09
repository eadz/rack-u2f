
class FidoToken < ApplicationRecord
end

RSpec.describe Rack::U2f::RegistrationStore::ActiveRecordStore do
  before { FidoToken.delete_all }
  include_examples 'a valid u2f store implimentation', described_class.new(FidoToken)

  it 'allows a custom model to be passed in' do
    custom_model = FidoToken
    ar_store = described_class.new(custom_model)
    expect(custom_model).to receive(:pluck)
    ar_store.key_handles
  end
end
