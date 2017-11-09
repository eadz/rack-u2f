require 'sqlite3'
require 'active_record'

# Set up a database that resides in RAM
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

# Set up database tables and columns
ActiveRecord::Schema.define do
  create_table :fido_tokens, force: true do |t|
    t.string :key_handle, index: true
    t.text :certificate
    t.text :public_key
    t.integer :counter
  end
end

# Set up model classes
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
