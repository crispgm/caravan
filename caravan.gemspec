# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "caravan/version"

Gem::Specification.new do |spec|
  spec.name          = "Caravan"
  spec.version       = Caravan::VERSION
  spec.authors       = ["David Zhang"]
  spec.email         = ["zhangwanlong@bytedance.com"]

  spec.summary       = %q{Simple watcher and deployer}
  spec.description   = %q{Caravan is a simple file watcher and deployer for local development.}
  spec.homepage      = "https://crispgm.github.io/caravan/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "listen"
  spec.add_dependency "colorize"
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
