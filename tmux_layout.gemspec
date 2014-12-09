# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tmux_layout/version'

Gem::Specification.new do |spec|
  spec.name          = "tmux_layout"
  spec.version       = TmuxLayout::VERSION
  spec.authors       = ["Cody Duval"]
  spec.email         = ["cody.duval@gmail.com"]
  spec.summary       = %q{Generates configuration strings for layouts in tmux}
  spec.description   = %q{Setting up pane splits in tmux is hard.  This makes it
                          slightly less hard.}
  spec.homepage      = "http://www.gitub.com/codyduval/tmux_layout"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "guard-rspec", "~> 4.3"
  spec.add_development_dependency "pry", "~> 0.1"
end
