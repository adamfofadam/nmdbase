require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/usr/bin'
  end
end

describe service('chef-client') do
  it { should be_enabled }
end

describe file('/etc/chef/client.rb') do
  it { should be_file }
  its(:content) { should match 'chef_server_url' }
  its(:content) { should match 'validation_client_name "chef-validator"' }
  its(:content) { should match 'node_name "default-ubuntu-1204"' }
end
