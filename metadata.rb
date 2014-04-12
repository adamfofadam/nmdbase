# encoding: utf-8
name 'nmdbase'
maintainer 'NewMedia! Denver'
maintainer_email 'support@newmediadenver.com'
license 'Apache 2.0'
description 'Acts as a base recipe for chef-client and security components
  (ldap/yubikey two factor authentication).'
version '1.0.0'
recipe 'nmdbase::default', 'Enables the chef-client service on a schedule in
  addition to each of the other recipes in this cookbook.'
recipe 'nmdbase::ldap', 'Installs and configures ldap pam authentication.'
recipe 'nmdbase::ssl', 'Manages the organization specific ssl certificates.'
recipe 'nmdbase::yubico', 'Installs and configures yubico pam authentication.'

depends 'chef-client'
depends 'apt'
depends 'openssh'
depends 'fail2ban'
