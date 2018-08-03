ENV['RACK_ENV'] = 'test'

require_relative '../config/application.rb'

RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec
  config.color_mode = true
  config.formatter = :documentation
  config.order = 'random'
end
