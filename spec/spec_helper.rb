require 'rack/test'

require 'coveralls'
Coveralls.wear!

require 'bundler/setup'
Bundler.setup

require 'alpha_card'

RSpec.configure do |config|
  config.order = 'random'
end
