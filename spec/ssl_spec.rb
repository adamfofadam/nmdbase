require 'chefspec'
require 'spec_helper'

describe 'nmdbase::ssl' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  before do
    stub_data_bag_item('nmdbase', 'ssl').and_return(
      'id' => 'ssl',
      '_default' => {
        'crt' =>  'test_crt',
        'key' => 'test_key'
      }
    )
  end

  it 'Installs the client key.' do
    expect(chef_run).to create_file('/etc/ssl/private/example.key').with(
      user: 'root',
      group: 'root',
      mode: 0644
    )

    expect(chef_run).to create_file('/etc/ssl/private/example.key')
      .with_content(/^test_key$/)
  end

  it 'Installs the client cert.' do
    expect(chef_run).to create_file('/etc/ssl/certs/example.crt').with(
      user: 'root',
      group: 'root',
      mode: 0644
    )

    expect(chef_run).to create_file('/etc/ssl/certs/example.crt')
      .with_content(/^test_crt$/)
  end

end
