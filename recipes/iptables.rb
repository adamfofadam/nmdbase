# encoding: utf-8
#
# Cookbook Name:: nmdbase
# Recipe:: iptables
#
# Author:: David Arnold
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

include_recipe 'simple_iptables'
include_recipe 'fail2ban'

simple_iptables_policy = node['nmdbase']['simple_iptables_policy']
simple_iptables_rules = node['nmdbase']['simple_iptables_rules']

unless simple_iptables_policy.nil?
  simple_iptables_policy.each do | _key, value |
    simple_iptables_policy value[:name] do
      table value[:table] if defined?(value[:table])
      policy value[:defined_policy]
    end
  end
end
unless simple_iptables_rules.nil?
  simple_iptables_rules.each do | _key, value |
    simple_iptables_rule value[:name] do
      chain value[:chain]
      rule value[:rule]
      jump value[:jump]
      weight value[:weight]
    end
  end
end

case node['platform_family']
when 'rhel'
  service 'iptables' do
    action :restart
    notifies :restart, 'service[fail2ban]', :delayed
  end
when 'debian'
  service 'fail2ban' do
    action :restart
  end
end
