#
# Cookbook Name:: hosts
# Recipe:: chef_dns
#
# Copyright 2009, Bitfluent
# Copyright 2011, Hedgehog (hedghogshiatus@gmail.com)
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

# Find all nodes, sorting by Chef ID so their
# order doesn't change between runs.
hosts = search(:node, "*:*", "X_CHEF_id_CHEF_X asc")
$stderr.puts hosts.inspect
localhost = nil

search(:node, "*", %w(ipaddress fqdn dns_aliases)) do |n|
  # node own's record, store in localhost
  if n["ipaddress"] == node[:ipaddress]
    localhost = n
  else
    hosts[n["ipaddress"]] = n
  end
end
$stderr.puts after
$stderr.puts hosts.inspect

template "/etc/hosts" do
  source "chef_dns_hosts.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :hosts => hosts,
    :localhost => localhost,
    :fqdn => node[:fqdn],
    :hostname => node[:hostname]
  )
end
