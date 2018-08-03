env = (ENV['RACK_ENV'] || :development)

require 'bundler'
Bundler.require :default, env.to_sym

Dir["#{File.dirname(__FILE__)}/../app/apis/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/../app/models/**/*.rb"].each { |f| require f }

module Application
  include ActiveSupport::Configurable
end

Application.configure do |config|
  config.root     = File.dirname(__FILE__)
  config.env      = ActiveSupport::StringInquirer.new(env.to_s)
  config.paths    = { 'db' => [File.dirname(__FILE__)] }
end

db_config = YAML.safe_load(File.read("#{File.dirname(__FILE__)}/database.yml"))[Application.config.env]
ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.establish_connection(db_config)
