
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/u2f/version'

Gem::Specification.new do |spec|
  spec.name          = 'rack-u2f'
  spec.version       = Rack::U2f::VERSION
  spec.authors       = ['Eaden McKee']
  spec.email         = ['mail@eaden.net']

  spec.summary       = 'rack middleware to add u2f authentication'
  spec.description   = 'rack middleware to add u2f authentication to a rack app. Includes registration.'
  spec.homepage      = 'https://github.com/eadz/rack-u2f'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|DemoApp)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # rails erb behaviour is monkeypatched :( so using mustache
  spec.add_dependency 'mustache', '~> 1.0'
  spec.add_dependency 'rack', '~> 2.0'
  spec.add_dependency 'u2f', '~> 1.0'

  spec.add_development_dependency 'activerecord', '>= 4.0'
  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'fakeredis', '~> 0.6.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'redis', '~> 3.2'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
end
