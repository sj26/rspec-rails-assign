require 'rspec/rails'
require 'rspec/rails/matchers/assign'

RSpec::Rails::ControllerExampleGroup.send :include, RSpec::Rails::Matchers::Assign
