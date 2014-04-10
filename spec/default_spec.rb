require 'chefspec'
require 'spec_helper'

describe "nmdbase::default" do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  before do
    stub_data_bag_item("nmdbase", "ldap").and_return(
      "id" => "ldap",
      "_default" => {
        "conf" =>  [
          "base dc=ldap,dc=example,dc=com",
          "uri ldap://ldap.example.com/",
          "ldap_version 3",
          "rootbinddn cn=admin,dc=ldap,dc=example,dc=com",
          "pam_password md5"
        ],
        "secret" => "test_ldap_secret" }
      )
    stub_data_bag_item("nmdbase", "yubico").and_return(
      "id" => "yubico",
      "_default" => { "id" => "test_yubico_id", "key" => "test_yubico_key" }
      )
    stub_command("test -f /var/run/pam-debug.log").and_return(false)
  end

  it "Includes the fail2ban recipe." do
    expect(chef_run).to include_recipe('fail2ban')
  end

  it "Configures this instance as an LDAP client." do
    expect(chef_run).to include_recipe('nmdbase::ldap')
  end

  it "Configures this instance as an Yubico API client." do
    expect(chef_run).to include_recipe('nmdbase::yubico')
  end

  it "Configures this instance as a chef client." do
    expect(chef_run).to include_recipe('chef-client::config')
  end

  it "Configures the chef-client service." do
    expect(chef_run).to include_recipe('chef-client::service')
  end
end
