require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require_relative '../server.rb'

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

# For RSpec 2.x and 3.x
RSpec.configure { |c| c.include RSpecMixin }

require 'rspec_api_documentation/dsl'

RspecApiDocumentation.configure do |config|
  config.app = Sinatra::Application
end
