# encoding: utf-8
#
# Cookbook Name:: nmdbase
# Recipe:: default
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
# limitations under the License. test
#
file "/etc/yum.repos.d/glusterfs-epel.repo" do
  action :delete
end
execute 'yum-update' do
  command 'yum update -y'
  action :run
end
execute 'yum-development-tools' do
  command 'yum groupinstall -y Development\ Tools'
  action :run
end


include_recipe 'chef-client::config'
include_recipe 'chef-client::service'
include_recipe 'logwatch'
include_recipe 'postfix'
%w(ntp vim-X11 vim-common vim-enhanced vim-minimal nano nc telnet cyrus-sasl-plain wget pip-python).each do |pkg|
  package pkg do
    action :upgrade
  end
end

execute 'agent_install' do
  command "curl --silent --show-error --header 'x-connect-key: 0412e27b045b0a34cc525f3d20207c9370810a68' 'https://kickstart.jumpcloud.com/Kickstart' | bash"
  path [ '/sbin', '/bin', '/usr/sbin', '/usr/bin' ]
  timeout 600
  creates '/opt/jc'
end

template '/usr/share/logwatch/default.conf/logwatch.conf' do
  source 'logwatch.conf.erb'
  mode 0644
  owner 'root'
  group 'root'
end

file '/etc/postfix/sasl_passwd' do
  content 'email-smtp.us-west-2.amazonaws.com AKIAJFMREBTT2KRZW2NA:Ap+4e9DHWpxN3EQtqRDJluXYeeud7bRNDa4uBj+I00EH'
  owner 'root'
  group 'root'
  mode '600'
end

execute "sasl_passwd generate db" do
  command "postmap hash:/etc/postfix/sasl_passwd"
end

certificates = Chef::EncryptedDataBagItem.load('nmdproxy', 'certs')[node.chef_environment]
certificates.each do |hostname, certs|
  nmdproxy_cert hostname do
    ca certs['ca']
    crt certs['crt']
    key certs['key']
  end
end

ssh_known_hosts_entry 'github.com'

bash 'install boto' do
  code <<-EOH
    pip install boto
    EOH
end

cookbook_file "/bin/s3upload" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end