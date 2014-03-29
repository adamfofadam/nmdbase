require 'chefspec'
require 'spec_helper'

# Write unit tests with ChefSpec - https://github.com/sethvargo/chefspec#readme
describe "base::ldap" do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  before do
    stub_data_bag_item("users", "ldap").and_return("id" => "ldap", "_default" => { "secret" => "test_ldap_secret" })
  end

  it "Installs the LDAP package to set this instance up as a client." do
    expect(chef_run).to install_package('libpam-ldap')
  end

  it "Configures the LDAP connection for this client." do
    expect(chef_run).to create_template('/etc/ldap.conf').with(
      user: 'root',
      group: 'root',
      mode: 0644
    )
    expect(chef_run).to render_file('/etc/ldap.conf').with_content(/^# This file is managed by chef. Changes will be lost.$/)
    expect(chef_run).to render_file('/etc/ldap.conf').with_content(/^base dc=ldap,dc=newmediadenver,dc=com$/)
    expect(chef_run).to render_file('/etc/ldap.conf').with_content(%r{^uri ldap://ldap.newmediadenver.com/$})
    expect(chef_run).to render_file('/etc/ldap.conf').with_content(/^ldap_version 3$/)
    expect(chef_run).to render_file('/etc/ldap.conf').with_content(/^rootbinddn cn=admin,dc=ldap,dc=newmediadenver,dc=com$/)
    expect(chef_run).to render_file('/etc/ldap.conf').with_content(/^pam_password md5$/)
  end

  it "Installs the LDAP secret authentication content." do
    expect(chef_run).to create_template('/etc/ldap.secret').with(
      user: 'root',
      group: 'root',
      mode: 0600
    )
    expect(chef_run).to render_file('/etc/ldap.secret').with_content(/^test_ldap_secret$/)
  end

  it "Modifies the Name Service Switch to use LDAP." do
    expect(chef_run).to create_template('/etc/nsswitch.conf').with(
      user: 'root',
      group: 'root',
      mode: 0644
    )
    expect(chef_run).to render_file('/etc/nsswitch.conf').with_content(/^# This file is managed by chef. Changes will be lost.$/)
    expect(chef_run).to render_file('/etc/nsswitch.conf').with_content(/^passwd: +ldap compat$/)
    expect(chef_run).to render_file('/etc/nsswitch.conf').with_content(/^group: +ldap compat$/)
    expect(chef_run).to render_file('/etc/nsswitch.conf').with_content(/^shadow: +ldap compat$/)
    expect(chef_run).to render_file('/etc/nsswitch.conf').with_content(/^hosts: +files dns$/)
    expect(chef_run).to render_file('/etc/nsswitch.conf').with_content(/^networks: +files$/)
    expect(chef_run).to render_file('/etc/nsswitch.conf').with_content(/^protocols: +db files$/)
    expect(chef_run).to render_file('/etc/nsswitch.conf').with_content(/^services: +db files$/)
    expect(chef_run).to render_file('/etc/nsswitch.conf').with_content(/^ethers: +db files$/)
    expect(chef_run).to render_file('/etc/nsswitch.conf').with_content(/^rpc: +db files$/)
    expect(chef_run).to render_file('/etc/nsswitch.conf').with_content(/^netgroup: +nis$/)
  end

  it "It configures the PAM common session to create users from LDAP." do
    expect(chef_run).to create_template('/etc/pam.d/common-session').with(
      user: 'root',
      group: 'root',
      mode: 0644
    )
    expect(chef_run).to render_file('/etc/pam.d/common-session').with_content(/^# This file is managed by chef. Changes will be lost.$/)
    expect(chef_run).to render_file('/etc/pam.d/common-session').with_content(/^session +\[default=1\] +pam_permit.so$/)
    expect(chef_run).to render_file('/etc/pam.d/common-session').with_content(/^session +requisite +pam_deny.so$/)
    expect(chef_run).to render_file('/etc/pam.d/common-session').with_content(/^session +required +pam_permit.so$/)
    expect(chef_run).to render_file('/etc/pam.d/common-session').with_content(/^session +optional +pam_umask.so$/)
    expect(chef_run).to render_file('/etc/pam.d/common-session').with_content(/^session +required +pam_unix.so$/)
    expect(chef_run).to render_file('/etc/pam.d/common-session').with_content(/^session +optional +pam_ldap.so$/)
    expect(chef_run).to render_file('/etc/pam.d/common-session').with_content(%r{^session +required +pam_mkhomedir.so skel=/etc/skel umask=0022$})
  end

end
