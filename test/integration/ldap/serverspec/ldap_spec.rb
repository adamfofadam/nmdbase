require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/usr/bin'
  end
end

describe package('libpam-ldap') do
  it { should be_installed }
end

describe file('/etc/ldap.conf') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match '^# This file is managed by chef. Changes will be lost.' }
  its(:content) { should match '^base dc=ldap,dc=newmediadenver,dc=com$' }
  its(:content) { should match '^uri ldap://ldap.newmediadenver.com/$' }
  its(:content) { should match '^ldap_version 3$' }
  its(:content) { should match '^rootbinddn cn=admin,dc=ldap,dc=newmediadenver,dc=com$' }
  its(:content) { should match '^pam_password md5$' }
end

describe file('/etc/nsswitch.conf') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match '^# This file is managed by chef. Changes will be lost.' }
  its(:content) { should match '^passwd: +ldap compat' }
  its(:content) { should match '^group: +ldap compat$' }
  its(:content) { should match '^shadow: +ldap compat$' }
end

describe file('/etc/pam.d/common-session') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match '^# This file is managed by chef. Changes will be lost.' }
  its(:content) { should match '^session +\[default=1\] +pam_permit.so' }
  its(:content) { should match '^session +requisite +pam_deny.so$' }
  its(:content) { should match '^session +required +pam_permit.so$' }
  its(:content) { should match '^session +optional +pam_umask.so$' }
  its(:content) { should match '^session +required +pam_unix.so$' }
  its(:content) { should match '^session +optional +pam_ldap.so$' }
  its(:content) { should match '^session +required +pam_mkhomedir.so skel=/etc/skel umask=0022$' }
end
