# encoding: utf-8
#
# Cookbook Name:: base
# Attributes:: default
#
# Author:: Kevin Bridges
# Copyright:: 2014, NewMedia Denver
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

### nmdbase::default
# No attributes. Everything that is unique is configured through databags.
# Define if encrypted databags are used.  Options are 'yes' or 'no'.
default['nmdbase']['use_encrypted_databags'] = 'no'

### nmdbase::ldap

default['nmdbase']['ldap']['sssd_conf]']['path'] = '/etc/sssd/sssd.conf'

# Manage nsswitch to enable LDAP.
default['nmdbase']['nsswitch'] = '/etc/nsswitch.conf'
# An array of LDAP configuration options to enable the node as a LDAP client.
case node['platform_family']
when 'rhel'
  default['nmdbase']['nsswitch_config'] = [
    'passwd: files sss',
    'group: files sss',
    'shadow: files sss',
    'hosts: files dns',
    'networks: files',
    'protocols: db files',
    'services: files sss',
    'ethers: db files',
    'rpc: db files',
    'netgroup: files sss',
    'automount: files'
]
when 'debian'
  default['nmdbase']['nsswitch_config'] = [
    'passwd:         files sss',
    'shadow:         files sss',
    'group:          files sss',
    'hosts:          files dns',
    'bootparams:     files',
    'ethers:         files',
    'netmasks:       files',
    'networks:       files',
    'protocols:      files',
    'rpc:            files',
    'services:       files',
    'netgroup:       files sss',
    'publickey:      files',
    'automount:      files',
    'aliases:        files'
  ]
end

# Modify the PAM common-session to create user system accounts from LDAP data.
default['nmdbase']['common_session'] = '/etc/pam.d/common-session'
default['nmdbase']['common_session_confg'] = [
  'session [default=1] pam_permit.so',
  'session requisite pam_deny.so',
  'session required pam_permit.so',
  'session optional pam_umask.so',
  'session required pam_unix.so',
  'session optional pam_ldap.so',
  'session required pam_mkhomedir.so skel=/etc/skel umask=0022'
]

### nmdbase::yubico
# An array of PAM sshd configuration options that should include enabling
# pam_yubico.so.  The recipe will read data_bags/nmdbase/yubico[pam_sshd_conf]
# if you prefer to store the array there.
yubiconf = 'auth required pam_yubico.so mode=client try_first_pass'
yubiconf << ' authfile=/etc/yubikey_mappings debug'
case node['platform_family']
when 'rhel'
  default['nmdbase']['pam']['sshd']['conf'] = [
  # Activate pam_yubico.so as the first item. If you create
  # data_bags/users/yubico.json with your "key" and "id" from
  # https://upgrade.yubico.com/getapikey/ it will be added to this string.
  # Otherwise, you should look into storing this data in the data_bag.
    yubiconf,
    'auth  required  pam_sepermit.so',
    'auth include  password-auth',
    'account    required     pam_nologin.so',
    'account    include  password-auth',
    'password  include password-auth',
    'session required  pam_selinux.so close',
    'session required  pam_loginuid.so',
    'session required  pam_selinux.so open env_params',
    'session optional  pam_keyinit.so  force revoke',
    'session include   password-auth'
]
when 'debian'
  default['nmdbase']['pam']['sshd']['conf'] = [
  # Activate pam_yubico.so as the first item. If you create
  # data_bags/users/yubico.json with your "key" and "id" from
  # https://upgrade.yubico.com/getapikey/ it will be added to this string.
  # Otherwise, you should look into storing this data in the data_bag.
    yubiconf,
  # Standard Un*x authentication.
    '@include common-auth',
  # Disallow non-root logins when /etc/nologin exists.
    'account    required     pam_nologin.so',
  # Standard Un*x authorization.
    '@include common-account',
  # Standard Un*x session setup and teardown.
    '@include common-session',
  # Print the message of the day upon successful login.
    'session optional pam_motd.so # [1]',
  # Print the status of the user's mailbox upon successful login.
    'session optional pam_mail.so standard noenv # [1]',
  # Set up user limits from /etc/security/limits.conf.
    'session required pam_limits.so',
  # Read environment variables from /etc/environment and
  # /etc/security/pam_env.conf.
    'session required pam_env.so # [1]',
  # In Debian 4.0 (etch), locale-related environment variables were moved to
  # /etc/default/locale, so read that as well
    'session required pam_env.so user_readenv=1 envfile=/etc/default/locale',
  # Standard Un*x password updating.
    '@include common-password'
  ]
  default['nmdbase']['common_auth'] = '/etc/pam.d/common-auth'
  auth_first = 'auth  [success=2 default=ignore] pam_unix.so nullok_secure '
  auth_first << 'try_first_pass'
  default['nmdbase']['common_auth_confg'] = [
    auth_first,
    'auth  [success=1 default=ignore] pam_sss.so use_first_pass',
    'auth    requisite                       pam_deny.so',
    'auth    required                        pam_permit.so',
    'auth    optional                        pam_cap.so'
  ]

end
# The path to the ssh PAM conf file.
default['nmdbase']['pam']['sshd']['path'] = '/etc/pam.d/sshd'

# Define yubikey mappings according to http://opensource.yubico.com/yubico-pam/
# if validating yubikeys from a file and not LDAP.
default['nmdbase']['yubico']['authfile'] = '/etc/yubikey_mappings'

## Define iptables policy and/or rules uses simple iptables
## https://github.com/rtkwlf/cookbook-simple-iptables

default['nmdbase']['simple_iptables_rules'] = nil

default['nmdbase']['simple_iptables_policy'] = nil
