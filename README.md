# assignment-group3

## Project Structure

Assignment is encapsuled by one wrapper cookbook 'assignment-group3'. This cookbook contains one recipe 'default' which contains "custom" as well as the references to execute the dependent cookbooks/recepies.

## Dependencies

Dependencies from Chef Supermarket

* openssh
* sudo
* nginx

## Attributes

node.default['openssh']['server']['protocol'] used to set the ssh protocol-version
node.default['openssh']['server']['permit_root_login'] used to enable/disable ssh root-login
node.default['openssh']['server']['password_authentication'] used to enable/disable ssh password authentication
node.default['authorization']['sudo']['users'] used to define which users shall have "sudo"-permissions
node.default['nginx']['port'] used to specify the ports to listen on
node.default['nginx']['version'] used to specify the package version to be installed
node.default['nginx']['default_site_enabled'] used to disable the default site
