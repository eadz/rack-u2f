# require 'rack/u2f/registration_middleware'
Rails.application.routes.draw do

  get 'protected' => 'demo#protect'
  get 'log_out' => 'demo#log_out'
  root to: 'demo#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
