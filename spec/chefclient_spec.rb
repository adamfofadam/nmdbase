require 'chefspec'
require 'chefspec/berkshelf'

# Write unit tests with ChefSpec - https://github.com/sethvargo/chefspec#readme
describe "base::default" do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it "logs a sample message" do
    expect(:chef_run).to write_log "replace this with a meaningful resource"
  end

  it 'includes chef-client::delete_validation' do
    expect(chef_run).to include_recipe('chef-client::delete_validation')
  end

end
