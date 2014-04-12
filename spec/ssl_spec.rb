# encoding: utf-8
require 'chefspec'
require 'spec_helper'

describe 'nmdbase::ssl' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  before do
    stub_data_bag_item('nmdbase', 'ssl').and_return(
      'id' => 'ssl',
      '_default' => [
        {
          'content' => 'test_crt_one',
          'path' => '/etc/ssl/certs/example_one.crt'
        },
        {
          'content' => 'test_key_two',
          'path' => '/etc/ssl/private/example_two.key'
        }
      ]
    )
  end

  it 'Installs a configured client cert.' do
    expect(chef_run).to create_file('/etc/ssl/certs/example_one.crt').with(
      user: 'root',
      group: 'root',
      mode: 0644
    )

    expect(chef_run).to create_file('/etc/ssl/certs/example_one.crt')
      .with_content(/^test_crt_one$/)
  end

  it 'Installs a configured client key.' do
    expect(chef_run).to create_file('/etc/ssl/private/example_two.key').with(
      user: 'root',
      group: 'root',
      mode: 0644
    )

    expect(chef_run).to create_file('/etc/ssl/private/example_two.key')
      .with_content(/^test_key_two$/)
  end

end
