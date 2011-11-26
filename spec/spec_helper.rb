require 'rails/all'

module RSpecRails
  class Application < ::Rails::Application
  end
end

require 'rspec/rails'
require 'rspec-rails-assign'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

