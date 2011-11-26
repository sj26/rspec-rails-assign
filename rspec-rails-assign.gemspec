# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "rspec-rails-assign"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Samuel Cochran"]
  s.email       = ["sj26@sj26.com"]
  s.homepage    = "http://github.com/sj26/rspec-rails-assign"
  s.summary     = "RSpec Rails assign matcher"
  s.description = "A subject-oriented way to match assignments in controller examples."

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "rspec-rails", "~> 2.0"
  s.add_development_dependency "rspec", "~> 2.7.0"

  s.files        = Dir["lib/**/*"] + %w[README.md LICENSE]
  s.require_path = 'lib'
end
