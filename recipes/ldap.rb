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

if node['nmdbase']['use_encrypted_databags'] == :yes
  sssd_ldap = Chef::EncryptedDataBagItem.load('nmdbase', 'sssd_ldap')
else
  sssd_ldap = data_bag_item('nmdbase', 'sssd_ldap')[node.chef_environment]
end

def create_nsswitch
  template node['nmdbase']['nsswitch'] do
    source 'generic.erb'
    mode 0644
    owner 'root'
    group 'root'
    variables(data: node['nmdbase']['nsswitch_config'])
  end
end

def install(ldap_packages)
  ldap_packages.each do |pkg|
    package pkg do
      action :install
    end
  end
end

case node['platform_family']
when 'rhel'
  ldap_packages = %w(sssd authconfig)
  install(ldap_packages)
  template node['nmdbase']['ldap']['sssd_conf]']['path'] do
    source 'generic.erb'
    mode 0600
    owner 'root'
    group 'root'
    variables(data: sssd_ldap['conf'])
  end
  create_nsswitch
  execute 'authconfig' do
    command 'authconfig --enablesssd --enablesssdauth --enablelocauthorize \
  --enablemkhomedir --update'
  end
  service 'sssd' do
    supports status: 'true', restart: 'true', reload: 'true'
    action [:enable, :start]
  end
when 'debian'
  ldap_packages = %w(sssd libpam-sss libnss-sss)
  install(ldap_packages)
  template node['nmdbase']['ldap']['sssd_conf]']['path'] do
    source 'generic.erb'
    mode 0600
    owner 'root'
    group 'root'
    variables(data: sssd_ldap['conf'])
  end
  template node['nmdbase']['common_session'] do
    source 'generic.erb'
    mode 0644
    owner 'root'
    group 'root'
    variables(data: node['nmdbase']['common_session_confg'])
  end
  create_nsswitch
  service 'sssd' do
    provider Chef::Provider::Service::Upstart
    action [:enable, :start]
  end
end
