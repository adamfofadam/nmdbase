# encoding: utf-8
require 'chefspec'
require 'spec_helper'

describe 'nmdbase::default' do
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
    stub_data_bag_item('nmdbase', 'yubico').and_return(
      'id' => 'yubico',
      '_default' => { 'id' => 'test_yubico_id', 'key' => 'test_yubico_key' }
      )
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
    stub_data_bag_item('nmdbase', 'sssd_ldap').and_return(
      'id' => 'sssd_ldap',
      '_default' => {
        'conf' =>  [
          '[sssd]',
          'config_file_version = 2',
          'services = nss, pam',
          'domains = default',
          '[nss]',
          'filter_users = root,ldap,named,avahi,haldaemon,dbus,radiusd,news,nscd',
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
    stub_command('test -f /var/run/pam-debug.log').and_return(false)
  end

  it 'Includes the fail2ban recipe.' do
    expect(chef_run).to include_recipe('fail2ban')
  end

  it 'Configures this instance as an LDAP client.' do
    expect(chef_run).to include_recipe('nmdbase::ldap')
  end

  it 'Configures this instance as an Yubico API client.' do
    expect(chef_run).to include_recipe('nmdbase::yubico')
  end

  it 'Configures this instance as a chef client.' do
    expect(chef_run).to include_recipe('chef-client::config')
  end

  it 'Configures the chef-client service.' do
    expect(chef_run).to include_recipe('chef-client::service')
  end
end
