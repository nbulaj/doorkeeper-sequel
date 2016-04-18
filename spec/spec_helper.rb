require 'rack/test'

require 'coveralls'
Coveralls.wear!

require 'bundler/setup'
Bundler.setup

# require gem

RSpec.configure do |config|
  config.order = 'random'
end
