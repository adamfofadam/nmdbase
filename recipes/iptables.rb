include_recipe 'simple_iptables::default'

simple_iptables_policy = node['nmdbase']['simple_iptables_policy']
simple_iptables_rules = node['nmdbase']['simple_iptables_rules']

unless simple_iptables_policy == ''
  simple_iptables_policy.each do | key, value |
    simple_iptables_policy value[:name] do
      if value[:table] then table value[:table]
      end
      policy value[:defined_policy]
    end
  end
end
unless simple_iptables_rules == ''
  simple_iptables_rules.each do | key, value |
    simple_iptables_rule value[:name] do
      chain value[:chain]
      rule value[:rule]
      jump value[:jump]
      weight value[:weight]
    end
  end
end

service 'iptables' do
  action :reload
end
