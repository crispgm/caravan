# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "caravan/version"

Gem::Specification.new do |spec|
  spec.name          = "caravan"
  spec.version       = Caravan::VERSION
  spec.authors       = ["David Zhang"]
  spec.email         = ["crispgm@gmail.com"]

  spec.summary       = %q{Simple project files watcher and deployer}
  spec.description   = %q{Caravan is a simple file watcher and deployer of project files for local development.}
  spec.homepage      = "https://crispgm.github.io/caravan/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|assets)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.3.0'

  spec.add_dependency "listen"
  spec.add_dependency "colorize"
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "shoulda-context"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 1.0.0"
end
