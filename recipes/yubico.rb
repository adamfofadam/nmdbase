#
# Cookbook Name:: yubico
# Recipe:: default
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

include_recipe 'openssh'

%w(python-software-properties).each do |pkg|
  package pkg do
    action :install
  end
end

case node['platform']
  # @TODO: Cover additional operating systems
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
  source "yubikey_mappings.erb"
  mode 0644
  owner "root"
  group "root"
end

bash "enable-yubico-pam" do
  user "root"
  action :run
  cmd = "echo -e \"auth required pam_yubico.so mode=client try_first_pass id=#{node['base']['yubico']['id']} key=#{node['base']['yubico']['key']} authfile=#{node['base']['yubico']['authfile']}\n$(cat /etc/pam.d/sshd)\" > /etc/pam.d/sshd"
  not_if "grep 'auth required pam_yubico.so' /etc/pam.d/sshd"
  code <<-EOH
    #{cmd}
  EOH
  notifies :restart, "service[ssh]", :delayed
end
