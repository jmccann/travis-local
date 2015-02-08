# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'travis-local/version'

Gem::Specification.new do |spec|
  spec.name          = 'travis-local'
  spec.version       = TravisLocal::VERSION
  spec.authors       = ['Jacob McCann']
  spec.email         = ['jacob.mccann2@target.com']
  spec.summary       = 'Run travis CI test suites locally'
  spec.description   = 'Run travis CI test suites locally'
  spec.homepage      = 'https://github.com/jmccann/travis-local'
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'open4', '~> 1.3'
end
