require 'rack/u2f/version'
require 'rack/u2f/helpers'
require 'rack/u2f/registration_server'
require 'rack/u2f/registration_store'
require 'rack/u2f/authentication_middleware'

module Rack
  # :nodoc:
  module U2f
    TEMPLATE_DIR = ::File.join(::File.dirname(__FILE__), 'u2f', 'templates')
    REGISTRATION_TEMPLATE = ::File.read(::File.join(TEMPLATE_DIR, 'registration_page.html.mustache'))
    CHALLENGE_TEMPLATE = ::File.read(::File.join(TEMPLATE_DIR, 'challenge_page.html.mustache'))
    U2FJS = ::File.read(::File.join(TEMPLATE_DIR, 'u2f.js'))
  end
end
