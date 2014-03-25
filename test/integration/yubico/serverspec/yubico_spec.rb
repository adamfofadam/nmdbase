require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/usr/bin'
  end
end

describe package('libpam-yubico') do
  it { should be_installed }
end

describe file('/etc/apt/sources.list.d/yubico-stable-precise.list') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match 'deb http://ppa.launchpad.net/yubico/stable/ubuntu precise main' }
  its(:content) { should match 'deb-src http://ppa.launchpad.net/yubico/stable/ubuntu precise main' }
end

describe file('/etc/pam.d/sshd') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match '^auth required pam_yubico.so mode=client try_first_pass id=15916 key=iqXJ1Moo70WCI4wrxBpniqvPDiw= authfile=/etc/yubikey_mappings debug$' }
end

describe file('/etc/ssh/sshd_config') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match '^ChallengeResponseAuthentication yes$' }
  its(:content) { should match '^UsePAM yes$' }
  its(:content) { should match '^PasswordAuthentication yes$' }
end

describe file('/etc/yubikey_mappings') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match '^vagrant:ccccccdivlul$' }
end
