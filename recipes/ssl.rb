# encoding: utf-8
#
# Cookbook Name:: nmdbase
# Recipe:: ssl
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
if node['nmdbase']['use_encrypted_databags'] == 'yes'
  # rubocop:disable LineLength
  ssl_data = Chef::EncryptedDataBagItem.load('nmdbase', 'ssl')[node.chef_environment]
# rubocop:enable LineLength
else
  ssl_data = data_bag_item('nmdbase', 'ssl')[node.chef_environment]
end

ssl_data.each do |cert|
  next if cert['path'].nil?
  file "cert: #{cert['path']}" do
    content cert['content']
    owner 'root'
    group 'root'
    mode 0644
    action :create
    path cert['path']
    not_if { cert['content'].nil? }
  end
end
