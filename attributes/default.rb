node.default['openssh']['client']['protocol'] = [ '2' ]
node.default['openssh']['server']['protocol'] = [ '2' ]
node.default['openssh']['server']['permit_root_login'] = 'no'
node.default['openssh']['server']['password_authentication'] = 'no'
node.default['authorization']['sudo']['users'] = ['ckappel', 'animmervoll']
node.default['nginx']['port'] = '8080'
node.default['nginx']['version'] = '1.12.1'
node.default['nginx']['default_site_enabled'] = false


