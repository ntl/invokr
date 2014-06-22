# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'invokr/version'

Gem::Specification.new do |spec|
  spec.name          = "invokr"
  spec.version       = Invokr::VERSION
  spec.authors       = %w(ntl)
  spec.email         = %w(nathanladd+github@gmail.com)
  spec.summary       = %q{Invoke methods with a consistent Hash interface.}
  spec.description   = %q{Invoke methods with a consistent Hash interface. Useful for metaprogramming.}
  spec.homepage      = "https://github.com/ntl/invokr"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = []
  spec.test_files    = spec.files.grep %r{test/}
  spec.require_paths = %w(lib)

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "rake"
end
