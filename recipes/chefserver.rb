template "/usr/bin/update_vagrant_hostname" do
  source "update_vagrant_hostname.erb"
  owner "root"
  group "root"
  mode "0755"
end

execute "update_vagrant_hostname" do
  command "/usr/bin/update_vagrant_hostname"
  action :run
end

