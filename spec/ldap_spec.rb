# encoding: utf-8
require 'chefspec'
require 'spec_helper'

describe 'nmdbase::ldap' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  before do
    stub_data_bag_item('nmdbase', 'ldap').and_return(
      'id' => 'ldap',
      '_default' => {
        'conf' =>  [
          'base dc=ldap,dc=example,dc=com',
          'uri ldap://ldap.example.com/',
          'ldap_version 3',
          'rootbinddn cn=admin,dc=ldap,dc=example,dc=com',
          'pam_password md5'
        ],
        'secret' => 'test_ldap_secret' }
      )
    stub_data_bag_item('nmdbase', 'sssd_ldap').and_return(
      'id' => 'sssd_ldap',
      '_default' => {
        'conf' =>  [
          '[sssd]',
          'config_file_version = 2',
          'services = nss, pam',
          'domains = default',
          '[nss]',
          # rubocop:disable LineLength, StringLiterals
          'filter_users = root,ldap,named,avahi,haldaemon,dbus,radiusd,news,nscd',
          # rubocop:enable LineLength, StringLiterals
          '[pam]',
          '[domain/default]',
          'ldap_schema = rfc2307bis',
          'ldap_user_fullname = displayName',
          'ldap_user_search_base = ou=people,dc=example,dc=com',
          'ldap_group_search_base = ou=groups,dc=example,dc=com',
          'ldap_group_member = member',
          'ldap_group_nesting_level = 4',
          'ldap_tls_reqcert = never',
          'auth_provider = ldap',
          'ldap_schema = rfc2307bis',
          'krb5_realm = EXAMPLE.COM',
          'ldap_search_base = dc=example,dc=com',
          'ldap_group_member = uniquemember',
          'id_provider = ldap',
          'ldap_id_use_start_tls = True',
          'chpass_provider = ldap',
          'ldap_uri = ldaps://ldap.example.com',
          'krb5_kdcip = kerberos.example.com',
          'cache_credentials = True',
          'ldap_tls_cacertdir = /etc/openldap/cacerts',
          'entry_cache_timeout = 600',
          'ldap_network_timeout = 3',
          'krb5_realm = EXAMPLE.COM',
          'krb5_server = kerberos.example.com'
        ]
      }
    )
  end

  case ENV['nmdbase_spec_os']
  when 'ubuntu'
    it 'Installs the LDAP package to set this instance up as a client.' do
      expect(chef_run).to install_package('libpam-ldap')
    end
    it 'Installs LDAP command line utilities.' do
      expect(chef_run).to install_package('ldap-utils')
    end
    it 'Configures the LDAP connection for this client.' do
      expect(chef_run).to create_template('/etc/ldap.conf').with(
         user: 'root',
         group: 'root',
         mode: 0644
       )
      expect(chef_run).to render_file('/etc/ldap.conf')
        .with_content(/^# This file was generated by Chef for*.+$/)
      expect(chef_run).to render_file('/etc/ldap.conf')
        .with_content(/^# Do NOT modify this file by hand!$/)
      expect(chef_run).to render_file('/etc/ldap.conf')
         .with_content(/^base dc=ldap,dc=example,dc=com$/)
      expect(chef_run).to render_file('/etc/ldap.conf')
        .with_content(%r{^uri ldap://ldap.example.com/$})
      expect(chef_run).to render_file('/etc/ldap.conf')
        .with_content(/^ldap_version 3$/)
      expect(chef_run).to render_file('/etc/ldap.conf')
        .with_content(/^rootbinddn cn=admin,dc=ldap,dc=example,dc=com$/)
      expect(chef_run).to render_file('/etc/ldap.conf')
        .with_content(/^pam_password md5$/)
    end
    it 'Installs the LDAP secret authentication content.' do
      expect(chef_run).to create_template('/etc/ldap.secret').with(
         user: 'root',
         group: 'root',
         mode: 0600
       )
      expect(chef_run).to render_file('/etc/ldap.secret')
         .with_content(/^test_ldap_secret$/)
    end
    it 'Configures the PAM common session to create users from LDAP.' do
      expect(chef_run).to create_template('/etc/pam.d/common-session').with(
        user: 'root',
        group: 'root',
        mode: 0644
      )
      expect(chef_run).to render_file('/etc/ldap.conf')
        .with_content(/^# This file was generated by Chef for*.+$/)
      expect(chef_run).to render_file('/etc/ldap.conf')
          .with_content(/^# Do NOT modify this file by hand!$/)
      expect(chef_run).to render_file('/etc/pam.d/common-session')
          .with_content(/^session +\[default=1\] +pam_permit.so$/)
      expect(chef_run).to render_file('/etc/pam.d/common-session')
          .with_content(/^session +requisite +pam_deny.so$/)
      expect(chef_run).to render_file('/etc/pam.d/common-session')
          .with_content(/^session +required +pam_permit.so$/)
      expect(chef_run).to render_file('/etc/pam.d/common-session')
          .with_content(/^session +optional +pam_umask.so$/)
      expect(chef_run).to render_file('/etc/pam.d/common-session')
          .with_content(/^session +required +pam_unix.so$/)
      expect(chef_run).to render_file('/etc/pam.d/common-session')
          .with_content(/^session +optional +pam_ldap.so$/)
      r = %r{^session +required +pam_mkhomedir.so skel=/etc/skel umask=0022$}
      expect(chef_run).to render_file('/etc/pam.d/common-session')
          .with_content(r)
    end
    it 'Modifies the Name Service Switch to use LDAP.' do
      expect(chef_run).to create_template('/etc/nsswitch.conf').with(
            user: 'root',
            group: 'root',
            mode: 0644
          )
      expect(chef_run).to render_file('/etc/nsswitch.conf')
          .with_content(/^# This file was generated by Chef for*.+$/)
      expect(chef_run).to render_file('/etc/nsswitch.conf')
          .with_content(/^# Do NOT modify this file by hand!$/)
      expect(chef_run).to render_file('/etc/nsswitch.conf')
          .with_content(/^passwd: +ldap compat$/)
      expect(chef_run).to render_file('/etc/nsswitch.conf')
          .with_content(/^group: +ldap compat$/)
      expect(chef_run).to render_file('/etc/nsswitch.conf')
          .with_content(/^shadow: +ldap compat$/)
      expect(chef_run).to render_file('/etc/nsswitch.conf')
          .with_content(/^hosts: +files dns$/)
      expect(chef_run).to render_file('/etc/nsswitch.conf')
          .with_content(/^networks: +files$/)
      expect(chef_run).to render_file('/etc/nsswitch.conf')
          .with_content(/^protocols: +db files$/)
      expect(chef_run).to render_file('/etc/nsswitch.conf')
          .with_content(/^services: +db files$/)
      expect(chef_run).to render_file('/etc/nsswitch.conf')
          .with_content(/^ethers: +db files$/)
      expect(chef_run).to render_file('/etc/nsswitch.conf')
          .with_content(/^rpc: +db files$/)
      expect(chef_run).to render_file('/etc/nsswitch.conf')
        .with_content(/^netgroup: +nis$/)
    end

  when 'rhel'
    it 'Installs the LDAP package to set this instance up as a client.' do
      expect(chef_run).to install_package('sssd')
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
        .with_content(/^# This file was generated by Chef for*.+$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^# Do NOT modify this file by hand!$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^\[sssd\]$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^config_file_version = 2$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^services = nss, pam$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^domains = default$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^\[nss\]$/)
      # rubocop:disable LineLength, StringLiterals
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
        .with_content(/^filter_users = root,ldap,named,avahi,haldaemon,dbus,radiusd,news,nscd$/)
      # rubocop:enable LineLength, StringLiterals
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^\[pam\]$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^\[domain\/default\]$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^ldap_schema = rfc2307bis$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^ldap_user_fullname = displayName$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^ldap_user_search_base = ou=people,dc=example,dc=com$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^ldap_group_search_base = ou=groups,dc=example,dc=com$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^ldap_group_member = member$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^ldap_group_nesting_level = 4$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^ldap_tls_reqcert = never$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^auth_provider = ldap$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^ldap_schema = rfc2307bis$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^krb5_realm = EXAMPLE.COM$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^ldap_search_base = dc=example,dc=com$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^ldap_group_member = uniquemember$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^id_provider = ldap$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^ldap_id_use_start_tls = True$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^chpass_provider = ldap$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(%r{ldap_uri = ldaps:\/\/ldap.example.com})
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^krb5_kdcip = kerberos.example.com$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^cache_credentials = True$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(%r{^ldap_tls_cacertdir = \/etc\/openldap\/cacerts$})
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^entry_cache_timeout = 600$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^ldap_network_timeout = 3$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^krb5_realm = EXAMPLE.COM$/)
      expect(chef_run).to render_file('/etc/sssd/sssd.conf')
       .with_content(/^krb5_server = kerberos.example.com$/)
    end
    it 'Installs/updates authconfig.' do
      expect(chef_run).to install_package('authconfig')
    end
  end
end
