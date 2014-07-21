# encoding: utf-8
require 'foodcritic'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'drud'

desc 'Generate the Readme.md file.'
task :readme do
  drud = Drud::Readme.new(File.dirname(__FILE__))
  drud.render
end

desc 'Run RuboCop style and lint checks'
RuboCop::RakeTask.new(:rubocop)

desc 'Run Foodcritic lint checks'
FoodCritic::Rake::LintTask.new(:foodcritic) do |t|
  t.options = { fail_tags: ['any'] }
end

description = 'Run ChefSpec examples. Specify OS to test either with rake '
description << '"spec[rhel]" (Redhat,centos etc) or rake "spec[ubuntu]". '
description << 'Defaults to both'
desc description
task :spec, :os do |os, args|
  os = args[:os]
  case os
  when 'rhel'
    RSpec::Core::RakeTask.new(:spec) do |t|
      t.rspec_opts = '--tag rhel'
    end
  when 'ubuntu'
    RSpec::Core::RakeTask.new(:spec) do |t|
      t.rspec_opts = '--tag ubuntu'
    end
  else
    puts "Unknown rspec operating system #{os}. Running all tests."
    RSpec::Core::RakeTask.new(:spec) do |t|
      t.rspec_opts = '--tag rhel --tag ubuntu'
    end
  end
end

desc 'Run all tests'
task test: [:rubocop, :foodcritic, :spec]
task default: :test

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new

  desc 'Alias for kitchen:all'
  task integration: 'kitchen:all'

  task test: :integration
rescue LoadError
  puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
end
