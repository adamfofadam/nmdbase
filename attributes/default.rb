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

default['base']['yubico']['id'] = 15916
default['base']['yubico']['key'] = 'iqXJ1Moo70WCI4wrxBpniqvPDiw='
default['base']['yubico']['authfile'] = '/etc/yubikey_mappings'
# @TODO: Use LDAP for this data
default['base']['yubico']['users'] = {
  'vagrant' => 'ccccccdivlul'
}
