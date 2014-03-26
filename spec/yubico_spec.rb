require 'chefspec'
require 'spec_helper'

# Write unit tests with ChefSpec - https://github.com/sethvargo/chefspec#readme
describe "base::yubico" do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  before do
    stub_command("grep 'auth required pam_yubico.so' /etc/pam.d/sshd").and_return(false)
  end
  it "Includes the openssh recipe." do
    expect(chef_run).to include_recipe('openssh')
  end
  it "Installs the openssh-client." do
    expect(chef_run).to install_package('openssh-client')
  end
  it "Installs the openssh-server." do
    expect(chef_run).to install_package('openssh-server')
  end

  it "Enables the ssh service." do
    expect(chef_run).to enable_service('ssh')
  end

  it "Starts the ssh service." do
    expect(chef_run).to start_service('ssh')
  end

  it "Creates the ssh configuration." do
    expect(chef_run).to create_template('/etc/ssh/ssh_config').with(
      user: 'root',
      group: 'root',
      mode: "0644"
    )
  end

  it "Creates the sshd configuration." do
    expect(chef_run).to create_template('/etc/ssh/sshd_config').with(
      user: 'root',
      group: 'root',
      mode: "0644"
    )
  end

  it "Installs python-software-properties." do
    expect(chef_run).to install_package('python-software-properties')
  end

  it "Adds the yubico repositories." do
    expect(chef_run).to run_execute('add-apt-repository')
  end

  it "Notifies apt-get update when adding yubico repositories." do
    cmd = chef_run.execute('add-apt-repository')
    expect(cmd).to notify('execute[apt-get-update]')
  end

  it "Installs the libpam-yubico package from the yubico repositories." do
    expect(chef_run).to install_package('libpam-yubico')
  end

  it "Creates a global yubico auth file." do
    expect(chef_run).to create_template('/etc/yubikey_mappings').with(
      user: 'root',
      group: 'root',
      mode: 0644
    )
  end

  it "Enables the yubico pam module." do
    expect(chef_run).to run_bash('enable-yubico-pam')
  end
end
