require 'rspec/core/rake_task'

require_relative 'config/application.rb'

desc 'Start IRB with application environment loaded'
task :console do
  exec 'irb -r./config/application'
end

desc 'Run the specs'
task :spec do
  RSpec::Core::RakeTask.new(:spec)
end
