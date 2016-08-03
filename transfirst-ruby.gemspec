# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'transfirst/ruby/version'

Gem::Specification.new do |spec|
  spec.name          = 'transfirst-ruby'
  spec.version       = Transfirst::Ruby::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Andolasoft']
  spec.email         = ['anurag.pattnaik@andolasoft.com']

  spec.summary       = %q{Transfirst API integration}
  spec.homepage      = 'https://github.com/andola-dev/transfirst-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
end
