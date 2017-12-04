# Assignment Group 3

# Install and start openssh server
include_recipe 'openssh::default'

# Edit ssh-config to allow Protocol version 2 only
ruby_block "ensure ssh protocol version 2" do
  block do
    fe = Chef::Util::FileEdit.new("/etc/ssh/ssh_config")
    fe.insert_line_if_no_match("/Protocol 2/", "Protocol 2")
    fe.write_file
  end
end

# service 'openssh' do
#	action :start
# end

# deploy message of the day
file "/etc/motd" do
	content node['platform'] + "\n" + node['platform_version'] + "13.6.4"
end

# create user group lecturer to be assigned to users later on
group 'lecturer' do
	action :create
	gid '401'
end

# create users and assign their group and home-directory
user 'ckappel' do
	action :create
	shell '/bin/zsh'
	home '/home/automationguy'
	gid 'lecturer'
end

user 'animmervoll' do
	action :create
	shell '/bin/zsh'
	home '/home/guru1'
	gid 'lecturer'
end

# create users home-directories
directory '/home/automationguy' do
  action :create
  owner 'ckappel'
  group 'lecturer'
  mode '0755'
end

directory '/home/guru1' do
  action :create
  owner 'animmervoll'
  group 'lecturer'
  mode '0755'
end

# set previously created users as sudo-users
include_recipe 'sudo::default'

# install and start nginx web-server
include_recipe 'nginx::default'

service 'nginx' do
	action :start
end

directory '/var/www/nginx' do
	action :create
	recursive true
end

# nginx_site "/var/www/nginx/index.html" do
#   template "custom_site.erb"
#   variables( :platform => node['platform'], :platform_version => node['platform_version'], :chef_version => '13.6.4' )
# end