#
# Cookbook Name:: base
# Recipe:: yubico
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
#
include_recipe 'openssh'

%w(python-software-properties).each do |pkg|
  package pkg do
    action :install
  end
end

case node['platform']
when 'debian', 'ubuntu'
  execute "add-apt-repository" do
    command "add-apt-repository ppa:yubico/stable"
    not_if { ::File.exists?("/etc/apt/sources.list.d/yubico-stable-precise.list") }
    notifies :run, "execute[apt-get-update]", :immediately
    action :run
  end
  execute "apt-get-update" do
    command "apt-get update"
    action :nothing
  end
  %w(libpam-yubico).each do |pkg|
    package pkg do
      action :install
    end
  end
end

template node['base']['yubico']['authfile'] do
  source "generic.erb"
  mode 0644
  owner "root"
  group "root"
  variables(:data => node['base']['yubico']['users'])
end

yubico_data = data_bag_item('users', 'yubico')[node.chef_environment]
if !yubico_data['id'].nil? && !yubico_data['key'].nil?
  # Need to make a deep copy of the original array because ruby is weird.
  sshd_conf = []
  node['base']['pam']['sshd']['conf'].each do |x|
    sshd_conf.push(/^auth required pam_yubico.so/.match(x) ? "#{x} id=#{yubico_data['id']} key=#{yubico_data['key']}" : x)
  end
else
  sshd_conf = node['base']['pam']['sshd']['conf']
end

template node['base']['pam']['sshd']['path'] do
  source "generic.erb"
  mode 0644
  owner "root"
  group "root"
  variables(:data => sshd_conf)
  notifies :restart, "service[ssh]", :delayed
end

# Debug logging is enabled by adding "debug" to node['base']['pam']['sshd']['conf']
bash 'Prepare for debug logging.' do
  code <<-EOH
  touch /var/run/pam-debug.log
  chmod go+w /var/run/pam-debug.log
  EOH
  creates "/var/run/pam-debug.log"
  not_if "test -f /var/run/pam-debug.log"
end
