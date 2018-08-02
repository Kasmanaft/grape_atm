require 'rspec/core/rake_task'

require_relative 'config/application.rb'

task :rails_env do
end

task :environment do
end

module Rails
  def self.application
    Struct.new(:config, :paths) do
      def load_seed
        require File.expand_path('../config/application', __FILE__)
        require File.expand_path('../db/seeds', __FILE__)
      end
    end.new(config, paths)
  end

  def self.config
    require 'erb'
    db_config = YAML.safe_load(ERB.new(File.read('config/database.yml')).result)
    Struct.new(:database_configuration) do
      def paths
        { 'db' => ['db'] }
      end
    end.new(db_config)
  end

  def self.paths
    { 'db/migrate' => ["#{root}/db/migrate"] }
  end

  def self.env
    env = ENV['RACK_ENV'] || 'development'
    ActiveSupport::StringInquirer.new(env)
  end

  def self.root
    File.dirname(__FILE__)
  end
end

Rake.load_rakefile 'active_record/railties/databases.rake'
