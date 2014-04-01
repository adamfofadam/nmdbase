#
# Cookbook Name:: base
# Attributes:: default
#
# Copyright (C) 2014 NewMedia! Denver support@newmediadenver.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# An array of PAM sshd configuration options that should include enabling
# pam_yubico.so
default['base']['pam']['sshd']['conf'] = [
  # Activate pam_yubico.so as the first item. If you create
  # data_bags/users/yubico.json with your "key" and "id" from
  # https://upgrade.yubico.com/getapikey/ it will be added to this string.
  # Otherwuse, you will need to add the id and key to this string.
  'auth required pam_yubico.so mode=client try_first_pass authfile=/etc/yubikey_mappings debug',
  # Standard Un*x authentication.
  '@include common-auth',
  # Disallow non-root logins when /etc/nologin exists.
  'account    required     pam_nologin.so',
  # Standard Un*x authorization.
  '@include common-account',
  # Standard Un*x session setup and teardown.
  '@include common-session',
  # Print the message of the day upon successful login.
  'session    optional     pam_motd.so # [1]',
  # Print the status of the user's mailbox upon successful login.
  'session    optional     pam_mail.so standard noenv # [1]',
  # Set up user limits from /etc/security/limits.conf.
  'session    required     pam_limits.so',
  # Read environment variables from /etc/environment and
  # /etc/security/pam_env.conf.
  'session    required     pam_env.so # [1]',
  # In Debian 4.0 (etch), locale-related environment variables were moved to
  # /etc/default/locale, so read that as well
  'session    required     pam_env.so user_readenv=1 envfile=/etc/default/locale',
  # Standard Un*x password updating.
  '@include common-password'
]
# The path to the ssh PAM conf file.
default['base']['pam']['sshd']['path'] = '/etc/pam.d/sshd'

# See http://opensource.yubico.com/yubico-pam/
default['base']['yubico']['authfile'] = '/etc/yubikey_mappings'
default['base']['yubico']['users'] = [
  'vagrant: ccccccdivlul'
]

# An array of LDAP configuration options to enable the node as a LDAP client.
default['base']['ldap']['conf'] = [
  'base dc=ldap,dc=newmediadenver,dc=com',
  'uri ldap://ldap.newmediadenver.com/',
  'ldap_version 3',
  'rootbinddn cn=admin,dc=ldap,dc=newmediadenver,dc=com',
  'pam_password md5'
]
default['base']['ldap']['path'] = '/etc/ldap.conf'
default['base']['ldap']['secret'] = '/etc/ldap.secret'

# Manage nsswitch here to add ldap.
default['base']['nsswitch'] = '/etc/nsswitch.conf'
# An array of LDAP configuration options to enable the node as a LDAP client.
default['base']['nsswitch_config'] = [
  'passwd: ldap compat',
  'group: ldap compat',
  'shadow: ldap compat',
  'hosts: files dns',
  'networks: files',
  'protocols: db files',
  'services: db files',
  'ethers: db files',
  'rpc: db files',
  'netgroup: nis'
]

# Modify the PAM common-session to create user accounts based on LDAP data.
default['base']['common_session'] = '/etc/pam.d/common-session'
default['base']['common_session_confg'] = [
  'session [default=1] pam_permit.so',
  'session requisite pam_deny.so',
  'session required pam_permit.so',
  'session optional pam_umask.so',
  'session required pam_unix.so',
  'session optional pam_ldap.so',
  'session required pam_mkhomedir.so skel=/etc/skel umask=0022'
]
