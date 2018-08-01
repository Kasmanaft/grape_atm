ENV['RACK_ENV'] = 'test'

require_relative '../../config/application.rb'

require 'capybara'
require 'capybara/cucumber'

Capybara.app = Atm.new
