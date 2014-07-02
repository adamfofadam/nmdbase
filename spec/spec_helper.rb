# encoding: utf-8
require 'chefspec'
require 'chefspec/berkshelf'
require 'simplecov'
SimpleCov.start do
  add_filter 'vendor/'
end
RSpec.configure do |config|
  # Specify the path for Chef Solo to find cookbooks
  # config.cookbook_path = '/var/cookbooks'

  # Specify the path for Chef Solo to find roles
  # config.role_path = '/var/roles'

  # Specify the Chef log_level (default: :warn)
  config.log_level = :error

  # Specify the path to a local JSON file with Ohai data
  # config.path = 'ohai.json'

  config.treat_symbols_as_metadata_keys_with_true_values = true

  # Use color output for RSpec
  config.color_enabled = true

  # Use documentation output formatter
  config.formatter = :documentation
end
