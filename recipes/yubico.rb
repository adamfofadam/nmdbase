# encoding: utf-8
#
# Cookbook Name:: nmdbase
# Recipe:: yubico
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
include_recipe 'openssh'

yubico_data = data_bag_item('nmdbase', 'yubico')[node.chef_environment]
attributes = node['nmdbase']['pam']['sshd']['conf']

case node['platform_family']
when 'debian'
  %w(python-software-properties).each do |pkg|
    package pkg do
      action :install
    end
  end
  execute 'add-software-properties-common' do
    command 'apt-get -y install software-properties-common'
    not_if { ::File.exist?('/usr/bin/add-apt-repository') }
  end
  path = '/etc/apt/sources.list.d/yubico-stable-precise.list'
  execute 'add-apt-repository' do
    command 'add-apt-repository ppa:yubico/stable'
    not_if { ::File.exist?(path) }
    notifies :run, 'execute[apt-get-update]', :immediately
    action :run
  end
  execute 'apt-get-update' do
    command 'apt-get update'
    action :nothing
  end
  %w(libpam-yubico).each do |pkg|
    package pkg do
      action :install
    end
  end
  databag = yubico_data['debian_pam_sshd_conf']
  # rubocop:disable LineLength, StringLiterals
  pam_sshd_conf = yubico_data['debian_pam_sshd_conf'].nil? ? attributes : databag
  # rubocop:enable LineLength, StringLiterals
when 'rhel'
  yum_repository 'epel' do
    description 'Extra Packages for Enterprise Linux'
    # rubocop:disable LineLength, StringLiterals
    mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
    # rubocop:enable LineLength, StringLiterals
    gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
    action :create
  end
  yum_package 'libyubikey' do
    action :upgrade
  end
  yum_package 'pam_yubico' do
    action :upgrade
  end
  databag = yubico_data['rhel_pam_sshd_conf']
  pam_sshd_conf = yubico_data['rhel_pam_sshd_conf'].nil? ? attributes : databag
end

template node['nmdbase']['yubico']['authfile'] do
  source 'generic.erb'
  mode 0644
  owner 'root'
  group 'root'
  variables(data: yubico_data['users'])
end

template node['nmdbase']['pam']['sshd']['path'] do
  source 'generic.erb'
  mode 0644
  owner 'root'
  group 'root'
  variables(data: pam_sshd_conf)
  notifies :restart, 'service[ssh]', :delayed
end

# Debug logging is enabled by adding a debug flag to the pam sshd conf. This
# sets up the server in case that flag is ever enabled.
bash 'Prepare for debug logging.' do
  code <<-EOH
  touch /var/run/pam-debug.log
  chmod go+w /var/run/pam-debug.log
  EOH
  creates '/var/run/pam-debug.log'
  not_if 'test -f /var/run/pam-debug.log'
end
