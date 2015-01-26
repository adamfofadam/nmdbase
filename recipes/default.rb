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
# limitations under the License.
#
if platform_family?('rhel')
  execute 'yum-update' do
    command 'yum update -y'
    action :run
  end
  execute 'yum-development-tools' do
    command 'yum groupinstall -y Development\ Tools'
    action :run
  end
end

# include_recipe 'fail2ban'
include_recipe 'nmdbase::ldap'
include_recipe 'nmdbase::yubico'
include_recipe 'chef-client::config'
include_recipe 'chef-client::service'
include_recipe 'logwatch'
include_recipe 'postfix'

package 'vim-X11' do
  action :install
end
package 'vim-common' do
  action :install
end
package 'vim-enhanced' do
  action :install
end
package 'vim-minimal' do
  action :install
end
package 'nano' do
  action :install
end
package 'nc' do
  action :install
end
package 'telnet' do
  action :install
end
package 'cyrus-sasl-plain' do
  action :install
end
package 'ntp' do
  action :install
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

