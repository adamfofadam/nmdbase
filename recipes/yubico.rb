include_recipe 'openssh'

package "python-software-properties" do
  action :install
end

case node['platform']
  # @TODO: Cover additional operating systems
when 'debian', 'ubuntu'
  execute "add-apt-repository" do
    command "add-apt-repository ppa:yubico/stable"
    not_if { ::File.exists?("/etc/apt/sources.list.d/yubico-stable-precise.list") }
    notifies :run, "execute[apt-get-update]", :immediately
  end
  execute "apt-get-update" do
    command "apt-get update"
    action :nothing
  end
  package "libpam-yubico" do
    action :install
  end
end

template node[:base][:yubico][:authfile] do
  source "yubikey_mappings.erb"
  mode 0644
  owner "root"
  group "root"
end

bash "Enable pam_yubico" do
  user "root"
  cmd = "echo -e \"auth required pam_yubico.so mode=client try_first_pass id=#{node[:base][:yubico][:id]} key=#{node[:base][:yubico][:key]} authfile=#{node[:base][:yubico][:authfile]}\n$(cat /etc/pam.d/sshd)\" > /etc/pam.d/sshd"
  not_if "grep 'auth required pam_yubico.so' /etc/pam.d/sshd"
  code <<-EOH
    #{cmd}
  EOH
  notifies :restart, "service[ssh]", :delayed
end
