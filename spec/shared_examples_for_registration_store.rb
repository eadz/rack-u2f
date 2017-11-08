RSpec.shared_examples "a valid u2f store implimentation" do |initialized_store|
  subject(:store) { initialized_store }

  describe '#store_registration' do
    it 'stores a u2f config' do
      store.store_registration(
        certificate: 'asd',
        key_handle: 'mykey', public_key: '123', counter: 1
      )
      expect(store.get_registration(key_handle: 'mykey')).to eq(
        'certificate' => 'asd', 'public_key' => '123', 'counter' => 1
      )
    end
  end

  describe '#key_handles' do
    it 'returns the key handles of stored keys' do
      store.store_registration(certificate: 'asd', key_handle: 'mykey', public_key: '123', counter: 1)
      store.store_registration(certificate: 'asd', key_handle: 'mykey2', public_key: '123', counter: 1)
      expect(store.key_handles).to eq(%w[mykey mykey2])
    end
  end

  describe '#update_registration' do
    it 'updates the counter, while maintaining existing data' do
      store.store_registration(certificate: 'asd', key_handle: 'mykey', public_key: '123', counter: 1)

      store.update_registration(key_handle: 'mykey', counter: 6)
      expect(store.get_registration(key_handle: 'mykey')).to eq(
        'certificate' => 'asd', 'public_key' => '123', 'counter' => 6
      )
    end
  end
end
