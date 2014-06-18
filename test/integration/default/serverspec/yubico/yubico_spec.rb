# encoding: utf-8
require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS
RSpec.configure do |c|
  c.before :all do
    c.path = '/usr/bin'
  end
end
if os[:family] == 'Debian'
  describe file('/etc/apt/sources.list.d/yubico-stable-precise.list') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    m = 'deb http://ppa.launchpad.net/yubico/stable/ubuntu precise main'
    its(:content) { should match m }
    m = 'deb-src http://ppa.launchpad.net/yubico/stable/ubuntu precise main'
    its(:content) { should match m }
  end
  describe package('libpam-yubico') do
    it { should be_installed }
  end
  describe file('/etc/ssh/sshd_config') do
    it { should be_file }
    it { should be_mode '644' }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should match '^# This file was generated by Chef for*.+$' }
    its(:content) { should match '^# Do NOT modify this file by hand!$' }
    its(:content) { should match '^ChallengeResponseAuthentication no$' }
    its(:content) { should match '^UsePAM yes$' }
  end
  describe file('/etc/pam.d/sshd') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
  describe file('/etc/pam.d/sshd') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
# rubocop:disable LineLength, StringLiterals
    its(:content) { should match 'auth required pam_yubico.so mode=client try_first_pass authfile=/etc/yubikey_mappings debug' }
    its(:content) { should match '@include common-auth' }
    its(:content) { should match 'account    required     pam_nologin.so' }
    its(:content) { should match '@include common-account' }
    its(:content) { should match 'session [success=ok ignore=ignore module_unknown=ignore default=bad]        pam_selinux.so close' }
    its(:content) { should match 'session    required     pam_loginuid.so' }
    its(:content) { should match 'session    optional     pam_keyinit.so force revoke' }
    its(:content) { should match '@include common-session' }
    its(:content) { should match 'session    optional     pam_motd.so # [1]' }
    its(:content) { should match 'session    optional     pam_mail.so standard noenv # [1]' }
    its(:content) { should match 'session    required     pam_limits.so' }
    its(:content) { should match 'session    required     pam_env.so # [1]' }
    its(:content) { should match 'session    required     pam_env.so user_readenv=1 envfile=/etc/default/locale' }
    its(:content) { should match 'session [success=ok ignore=ignore module_unknown=ignore default=bad]        pam_selinux.so open' }
# rubocop:enable LineLength, StringLiterals
    its(:content) { should match '@include common-password' }
  end
elsif os[:family] == 'RedHat'
  describe file('/etc/ssh/sshd_config') do
    it { should be_file }
    it { should be_mode '600' }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should match '^# This file was generated by Chef for*.+$' }
    its(:content) { should match '^# Do NOT modify this file by hand!$' }
    its(:content) { should match '^ChallengeResponseAuthentication no$' }
    its(:content) { should match '^UsePAM yes$' }
  end
  describe file('/etc/pam.d/sshd') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
# rubocop:disable LineLength, StringLiterals
    its(:content) { should match 'auth required pam_yubico.so mode=client try_first_pass authfile=/etc/yubikey_mappings debug' }
# rubocop:enable LineLength, StringLiterals
    its(:content) { should match 'auth  required  pam_sepermit.so' }
    its(:content) { should match 'auth include  password-auth' }
    its(:content) { should match 'account    required     pam_nologin.so' }
    its(:content) { should match 'account    include  password-auth' }
    its(:content) { should match 'password  include password-auth' }
    its(:content) { should match 'session required  pam_selinux.so close' }
    its(:content) { should match 'session required  pam_loginuid.so' }
# rubocop:disable LineLength, StringLiterals
    its(:content) { should match 'session required  pam_selinux.so open env_params' }
    its(:content) { should match 'session optional  pam_keyinit.so  force revoke' }
# rubocop:enable LineLength, StringLiterals
    its(:content) { should match 'session include   password-auth' }
  end
  describe package('pam_yubico') do
    it { should be_installed }
  end
end
