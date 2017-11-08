# require 'rack/u2f/registration_middleware'
Rails.application.routes.draw do
  root to: 'demo#index'
  get 'demo/index'

  get 'demo/protect'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Rack::U2f::RegistrationServer.new({}), at: '/u2f_registration'

end
