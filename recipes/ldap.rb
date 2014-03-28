#
# Cookbook Name:: ldap
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

%w(libpam-ldap).each do |pkg|
  package pkg do
    action :install
  end
end

template node['base']['ldap'] do
  source "key_value.erb"
  mode 0644
  owner "root"
  group "root"
  variables({
    :data => node['base']['ldap_config'],
    :delimiter => " "
  })
end

ldap_data = data_bag_item('users', 'ldap')[node.chef_environment]
template node['base']['ldap_secret'] do
  source "ldap.secret.erb"
  mode 0600
  owner "root"
  group "root"
  variables({
     :secret => ldap_data['secret']
  })
end

template node['base']['nsswitch'] do
  source "key_value.erb"
  mode 0644
  owner "root"
  group "root"
  variables({
    :data => node['base']['nsswitch_config'],
    :delimiter => ": "
  })
end

template node['base']['common_session'] do
  source "key_value.erb"
  mode 0644
  owner "root"
  group "root"
  variables({
    :data => node['base']['common_session_confg'],
    :delimiter => " "
  })

end
