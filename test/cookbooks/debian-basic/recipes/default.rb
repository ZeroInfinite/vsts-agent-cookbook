#### Begin prepare system ####
include_recipe 'apt::default'
include_recipe 'build-essential::default'

user 'vagrant' do
  supports :manage_home => true
  comment 'Vagrant user'
  home '/home/vagrant'
  shell '/bin/bash'
  not_if 'id -u vagrant'
end

user 'builder' do
  supports :manage_home => true
  comment 'Builder user'
  home '/home/builder'
  shell '/bin/bash'
end

#### End prepare system ####

include_recipe 'vsts_agent::default'

agent1_name = "#{node['hostname']}_01"
agent2_name = "#{node['hostname']}_02"

agents_dir = '/home/vagrant/agents'

# cleanup
vsts_agent agent1_name do
  vsts_token node['vsts_agent_test']['vsts_token']
  action :remove
end

vsts_agent agent2_name do
  vsts_token node['vsts_agent_test']['vsts_token']
  action :remove
end

# # Agent1
vsts_agent agent1_name do
  install_dir "#{agents_dir}/#{agent1_name}"
  user 'vagrant'
  group 'vagrant'
  vsts_url node['vsts_agent_test']['vsts_url']
  vsts_pool node['vsts_agent_test']['vsts_pool']
  vsts_token node['vsts_agent_test']['vsts_token']
  action :install
end

vsts_agent agent1_name do
  action :restart
end

vsts_agent agent1_name do
  vsts_token node['vsts_agent_test']['vsts_token']
  action :remove
end

# Agent2
vsts_agent agent2_name do
  install_dir "#{agents_dir}/#{agent2_name}"
  user 'builder'
  group 'builder'
  path '/usr/local/bin/:/usr/bin:/opt/bin/'
  env('M2_HOME' => '/opt/maven', 'JAVA_HOME' => '/opt/java')
  vsts_url node['vsts_agent_test']['vsts_url']
  vsts_pool node['vsts_agent_test']['vsts_pool']
  vsts_token node['vsts_agent_test']['vsts_token']
  action :install
end

vsts_agent agent2_name do
  action :restart
end
