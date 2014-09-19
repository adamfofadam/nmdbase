# encoding: utf-8
#
# Cookbook Name:: nmdbase
# Recipe:: default
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

include_recipe 'fail2ban'
if node['nmdbase']['include_iptables']
  include_recipe 'nmdbase::iptables'
end
include_recipe 'nmdbase::ldap'
include_recipe 'nmdbase::yubico'
include_recipe 'chef-client::config'
include_recipe 'chef-client::service'
include_recipe 'logwatch'
include_recipe 'postfix'

package "vim-X11" do
  action :install
end
package "vim-common" do
  action :install
end
package "vim-enhanced" do
  action :install
end
package "vim-minimal" do
  action :install
end
package "nc" do
  action :install
end
