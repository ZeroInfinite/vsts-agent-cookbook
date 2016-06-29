#### Begin prepare system ####
user 'builder' do
  comment 'Builder user'
  home '/home/builder'
  shell '/bin/bash'
  password 'Pas$w0r_d'
end

grant_logon_as_service 'vagrant'
grant_logon_as_service 'builder'

#### End prepare system ####

include_recipe 'vsts_agent::default'

agent1_name = "win_#{node['hostname']}_01"
agent2_name = "win_#{node['hostname']}_02"
agent3_name = "win_#{node['hostname']}_03"

agents_dir = 'C:\\Users\\vagrant\\agents'

# cleanup
# vsts_agent agent1_name do
#   vsts_token node['vsts_agent_test']['vsts_token']
#   action :remove
# end

# vsts_agent agent2_name do
#   vsts_token node['vsts_agent_test']['vsts_token']
#   action :remove
# end

# vsts_agent agent3_name do
#   vsts_token node['vsts_agent_test']['vsts_token']
#   action :remove
# end

# Agent1
vsts_agent agent1_name do
  version '2.102.0'
  install_dir "#{agents_dir}/#{agent1_name}"
  user 'vagrant'
  vsts_url node['vsts_agent_test']['vsts_url']
  vsts_pool node['vsts_agent_test']['vsts_pool']
  vsts_token node['vsts_agent_test']['vsts_token']
  windowslogonaccount 'vagrant'
  windowslogonpassword 'vagrant'
  action :install
end

vsts_agent agent1_name do
  action :restart
end

# vsts_agent agent1_name do
#   vsts_token node['vsts_agent_test']['vsts_token']
#   action :remove
# end

# Agent2
vsts_agent agent2_name do
  version '2.102.0'
  install_dir "#{agents_dir}/#{agent2_name}"
  user 'builder'
  vsts_url node['vsts_agent_test']['vsts_url']
  vsts_pool node['vsts_agent_test']['vsts_pool']
  vsts_token node['vsts_agent_test']['vsts_token']
  windowslogonaccount 'NT AUTHORITY\\NetworkService'
  action :install
end

vsts_agent agent2_name do
  action :restart
end

# Agent3
vsts_agent agent3_name do
  version '2.102.1'
  install_dir "#{agents_dir}/#{agent3_name}"
  user 'builder'
  vsts_url node['vsts_agent_test']['vsts_url']
  vsts_pool node['vsts_agent_test']['vsts_pool']
  vsts_token node['vsts_agent_test']['vsts_token']
  windowslogonaccount 'builder'
  windowslogonpassword 'Pas$w0r_d'
  action :install
end