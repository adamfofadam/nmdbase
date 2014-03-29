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

# See http://opensource.yubico.com/yubico-pam/

default['base']['yubico']['id'] = "15916"
default['base']['yubico']['key'] = 'iqXJ1Moo70WCI4wrxBpniqvPDiw='
default['base']['yubico']['authfile'] = '/etc/yubikey_mappings'
# @TODO: Use LDAP for this data
default['base']['yubico']['users'] = {
  'vagrant' => 'ccccccdivlul'
}

default['base']['ldap'] = '/etc/ldap.conf'
default['base']['ldap_secret'] = '/etc/ldap.secret'
default['base']['ldap_debug'] = true
default['base']['ldap_config'] = [
  %W(base dc=ldap,dc=newmediadenver,dc=com),
  %W(uri ldap://ldap.newmediadenver.com/),
  %W(ldap_version 3),
  %W(rootbinddn cn=admin,dc=ldap,dc=newmediadenver,dc=com),
  %W(pam_password md5)
]
default['base']['nsswitch_config'] = [
  ['passwd', 'ldap compat'],
  ['group', 'ldap compat'],
  ['shadow', 'ldap compat'],
  ['hosts', 'files dns'],
  %W(networks files),
  ['protocols', 'db files'],
  ['services', 'db files'],
  ['ethers', 'db files'],
  ['rpc', 'db files'],
  %W(netgroup nis)
]
default['base']['common_session_confg'] = [
  ['session [default=1]', 'pam_permit.so'],
  ['session requisite', 'pam_deny.so'],
  ['session required', 'pam_permit.so'],
  ['session optional', 'pam_umask.so'],
  ['session required', 'pam_unix.so'],
  ['session optional', 'pam_ldap.so'],
  ['session required', 'pam_mkhomedir.so skel=/etc/skel umask=0022']
]
default['base']['nsswitch'] = '/etc/nsswitch.conf'
default['base']['common_session'] = '/etc/pam.d/common-session'
