# encoding: utf-8
require 'chefspec'
require 'spec_helper'

describe 'nmdbase::slogan' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'Creates a global slogan file.' do
    expect(chef_run).to create_template('/etc/slogan').with(
      user: 'root',
      group: 'root',
      mode: 0644
    )
  end

end
