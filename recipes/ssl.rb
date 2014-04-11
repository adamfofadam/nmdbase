#
# Cookbook Name:: nmdbase
# Recipe:: ssl
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

ssl_data = data_bag_item('nmdbase', 'ssl')[node.chef_environment]

file node['nmdbase']['ssl']['key'] do
  content ssl_data['key']
  owner "root"
  group "root"
  mode 0644
  action :create
  not_if { ssl_data['key'].nil? }
end

file node['nmdbase']['ssl']['crt'] do
  content ssl_data['crt']
  owner "root"
  group "root"
  mode 0644
  action :create
  not_if { ssl_data['crt'].nil? }
end
