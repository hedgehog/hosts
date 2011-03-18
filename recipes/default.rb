# Find all nodes, sorting by Chef ID so their
# order doesn't change between runs.
hosts = search(:node, "*:*", "X_CHEF_id_CHEF_X asc")
chef_server = search(:node, 'run_list:recipe\[chef\:\:server\]')

template "/etc/hosts" do
  source "hosts.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :hosts => hosts,
    :fqdn => node[:fqdn],
    :hostname => node[:hostname]
  )
end
