# require 'sqlite3'
# require 'grape'
# require 'json'
env = (ENV['RACK_ENV'] || :development)
require 'bundler'
Bundler.require :default, env.to_sym
require 'erb'

require_relative '../app/apis/atm.rb'
Dir["#{File.dirname(__FILE__)}/../app/models/**/*.rb"].each { |f| require f }
# require_relative '../db/db_setup'

module Application
  include ActiveSupport::Configurable
end

Application.configure do |config|
  config.root     = File.dirname(__FILE__)
  config.env      = ActiveSupport::StringInquirer.new(env.to_s)
  config.paths    = { 'db' => [File.dirname(__FILE__)] }
end

db_config = YAML.safe_load(ERB.new(File.read("#{File.dirname(__FILE__)}/database.yml")).result)[Application.config.env]
ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.establish_connection(db_config)
