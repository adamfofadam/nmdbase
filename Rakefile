# encoding: utf-8
require 'foodcritic'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

desc 'Run RuboCop style and lint checks'
Rubocop::RakeTask.new(:rubocop)

desc 'Run Foodcritic lint checks'
FoodCritic::Rake::LintTask.new(:foodcritic) do |t|
  t.options = { fail_tags: ['any'] }
end

desc 'Run ChefSpec examples'
RSpec::Core::RakeTask.new(:spec)

namespace :docs do
  def update_readme (preheader, postheader, content)
    output = true
    new_readme = ''
    possible_match = false
    definite_match = false
    match_length = 0
    state = 'pre'
    File.open('README.md', 'r') do |readme|
      while line = readme.gets
        if possible_match
          if line.gsub("\n",'').length == match_length
            definite_match = true
          end
          possible_match = false
          match_length = 0
        end
        if line =~ /^#{preheader}$/
          possible_match = true
          match_length = preheader.length
          state = 'pre'
        end
        if line =~ /^#{postheader}$/
          possible_match = true
          match_length = postheader.length
          state = 'post'
        end
        new_readme << line if output
        if definite_match
          new_readme << content if state == 'pre'
          output = false if state == 'pre'
          if state == 'post'
            new_readme << "\n#{postheader}\n#{line}"
            output = true
          end
          definite_match = false
        end
      end
    end
    File.open('README.md', 'w') { |file| file.write(new_readme) }
  end
  desc 'Update attributes section of the Readme.'
  task :attributes do
    documented_attributes = ''
    File.open('attributes/default.rb', 'r') do |readme|
      output = false
      while line = readme.gets
        output = true if line =~ /^###/
        if output
          documented_attributes << "\n#{line}" if line =~ /^###/
          documented_attributes << "    #{line}" unless line =~ /^###/
        end
      end
    end
    update_readme("Attributes", "Recipes", documented_attributes)
  end

  desc 'Update recipes section of the Readme.'
  task :recipes do
    documentation = ''
    Dir.glob('spec/*_spec.rb').sort.each do |f|
      File.open(f, 'r') do |spec|
        while line = spec.gets
          recipe = line.match(/^describe.+['|"](\w+::\w+)/i)
          documentation << "\n### #{recipe[1]}\n" unless recipe.nil?
          describes =line.match(/ +it '([^']+)/)
          documentation << "    #{describes[1]}\n" unless describes.nil?
        end
      end
    end
    update_readme("Recipes", "Testing", documentation)
  end

  desc 'Update Testing section of the Readme.'
  task :testing do
    documentation="\n"
    s=`rake -T`.split("\n")
    s.each do |l|
      documentation << "    #{l}\n" if l =~ /^rake/
    end
    update_readme("Testing", "License and Author", documentation)
  end

  task :all => [:attributes, :recipes, :testing]

  desc 'Parse metadata'
  task :metadata do
    require 'chef/cookbook/metadata'
    metadata = Chef::Cookbook::Metadata.new
    metadata.from_file('metadata.rb')
    documentation = ''
    documentation << "__#{metadata.name} #{metadata.version}__ by #{metadata.maintainer} - #{metadata.description}"
# puts metadata.inspect
# output cookbook dependencies
# metadata.dependencies.each { |cookbook, version| puts "#{cookbook} #{version}" }
update_readme("Metadata", "Requirements", documentation)


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
