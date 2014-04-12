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
%w(libpam-ldap ldap-utils).each do |pkg|
  package pkg do
    action :install
  end
end

ldap = data_bag_item('nmdbase', 'ldap')[node.chef_environment]
template node['nmdbase']['ldap']['path'] do
  source 'generic.erb'
  mode 0644
  owner 'root'
  group 'root'
  variables(data: ldap['conf'])
end

template node['nmdbase']['ldap']['secret'] do
  source 'ldap.secret.erb'
  mode 0600
  owner 'root'
  group 'root'
  variables(secret: ldap['secret'])
end

template node['nmdbase']['nsswitch'] do
  source 'generic.erb'
  mode 0644
  owner 'root'
  group 'root'
  variables(data: node['nmdbase']['nsswitch_config'])
end

template node['nmdbase']['common_session'] do
  source 'generic.erb'
  mode 0644
  owner 'root'
  group 'root'
  variables(data: node['nmdbase']['common_session_confg'])
end
