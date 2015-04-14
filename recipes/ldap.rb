# encoding: utf-8
#
# Cookbook Name:: nmdbase
# Recipe:: ldap
#
# Author:: Kevin Bridges
# Copyright:: 2014, NewMedia Denver
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

sssd_ldap = Chef::EncryptedDataBagItem.load('nmdbase', 'sssd_ldap')[node.chef_environment]

%w(sssd authconfig).each do |pkg|
  package pkg do
    action :install
  end
end

template node['nmdbase']['ldap']['sssd_conf]']['path'] do
  source 'generic.erb'
  mode 0600
  owner 'root'
  group 'root'
  variables(data: sssd_ldap['conf'])
end
template node['nmdbase']['nsswitch'] do
  source 'generic.erb'
  mode 0644
  owner 'root'
  group 'root'
  variables(data: node['nmdbase']['nsswitch_config'])
end
execute 'authconfig' do
  command 'authconfig --enablesssd --enablesssdauth --enablelocauthorize \
--enablemkhomedir --update'
end
service 'sssd' do
  supports status: 'true', restart: 'true', reload: 'true'
  action [:enable, :start]
end

