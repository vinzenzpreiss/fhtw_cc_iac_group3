# encoding: utf-8
# copyright: 2017, Christoph Kappel

title 'Topic 3'

# you add controls here
control 'openssh-task' do
  impact 1                              
  title 'OpenSSH Server'            
  desc 'OpenSSH Server in latest version should be installed (3 PTS)
          - SSH Protocol Version 1 MUST be disabled
          - SSH Protocol Version 2 MUST be enabled
          - no root login should be allowed
  '
  describe package('openssh-server') do                  
    it { should be_installed }
  end
  describe sshd_config do
    its('Protocol') { should cmp 2 }
    its('Protocol') { should_not cmp 1 }
  end
  describe sshd_config do
    its('PermitRootLogin') { should match(/no|without-password/) }
  end
end

control 'etc-motd' do
  impact 1                              
  title 'Message of the Day'            
  desc 'Deploy a message of the day (1 PTS)
          - owned by root
          - print following information (automatically determined by IaC Tool)
          - OS Name
          - OS Version
          - IaC Tool Version  
  '
  describe file('/etc/motd') do                  
    it { should exist }
    it { should be_file }
    it { should_not be_directory }
    its('content') {should include('Ubuntu')}    
    its('content') {should include('16.04')}
    its('content') {should include('13')}
  end
end

control 'u-ckappel' do
  impact 1                              
  title 'Users for Lecturer'            
  desc 'User ckappel must be on the system (1 PTS)
          - He wants to use a zsh shell
          - He must be a sudo user
          - His public ssh key must be deployed
          - He must be able to login via ssh
          - His home must be /home/automationguy
  '
  describe user('ckappel') do                  
    it { should exist }
    its('home') { should eq '/home/automationguy' }
    its('shell') { should eq '/bin/zsh' }
    its('groups') { should eq ['lecturer']}
  end

  describe directory('/home/automationguy') do                  
    it { should_not be_file }
    it { should be_directory }
    its('owner') { should eq 'ckappel' }        
  end

  describe directory('/home/automationguy/.ssh') do                  
    it { should_not be_file }
    it { should be_directory }
    its('owner') { should eq 'ckappel' }    
  end

  describe file('/home/automationguy/.ssh/authorized_keys') do                  
    it { should be_file }
    it { should_not be_directory }
    its('owner') { should eq 'ckappel' }    
    its('content') {should include('ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8P/xCm04oGnW48GtGGHOBnrM6PBThwo0213DGf1Q8b+8Nau/g3Yk1F+yToLT85GfqHBiLEBP1WGsAVgIcoluE5JWl03PJnz8WcoVh7I5nYiuSjhFAguNc8z/0qHypWpU+VmWfQnee7yGTIBHF27TBouSwBjsJKBkYaTzF7llVAYy873v6K6Owmfx28YxhrZEx1HgyoHl6AbYZh9dmbRsMtO3WR6hThtTfiFSHa/XNEMsB/VTF8aQOXFy3BYqCe1CWQ6QNZpdZwRep2cVqiRKlzv1JXS+R8PbdGkMMq/e92J4p1e+4qea3BjQLozY8rvneVYaooYFeFGzRvi18ceCV christoph@bytesource.net')}
  end
end

control 'u-animmervoll' do
  impact 1                              
  title 'User for Lecturer'            
  desc 'User animmervoll must be on the system (1 PTS)
          - He wants to use a zsh shell
          - He must not be a sudo user
          - He must be able to login via ssh
          - His home must be /home/guru1
          - He must be a group member of lecturer
  '
  describe user('animmervoll') do                  
    it { should_not exist }
    its('home') { should eq '/home/guru1' }
    its('shell') { should eq '/bin/zsh' }
    its('groups') { should eq ['lecturer']}
  end

  describe directory('/home/guru1') do                  
    it { should_not be_file }
    it { should be_directory }
    its('owner') { should eq 'animmervoll' }    
  end

  describe directory('/home/guru1/.ssh') do                  
    it { should_not be_file }
    it { should be_directory }
    its('owner') { should eq 'animmervoll' }
  end
end

control 'service-nginx' do
  impact 1                              
  title 'NGINX system service'            
  desc 'NGINX should be running (1 PTS)'

  describe service('nginx') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end

control 'package-nginx' do
  impact 1                              
  title 'NGINX must be installed'            
  desc 'NGINX (6 PTS)
        - 1.12.1 version
        - listen on port 8080, 8443
        - serve TLS
        - TLS 1.2 is allowed
        - RC4 is not allowed
        serves a index.html under /var/www/nginx/index.html
        following information (automatically determined by IaC Tool)
        - OS Name
        - OS Version
        - IaC Tool Version
        
        Example:
          Ubuntu
          16.04
          13.1.1
    
'  
  describe port(8080) do
    it { should be_listening }
  end
  describe port(8443) do
    it { should be_listening }
  end
  describe ssl(host:'localhost',port:8443).protocols('ssl2') do
    it { should_not be_enabled }
  end
  describe ssl(host:'localhost',port:8443).protocols('ssl3') do
    it { should_not be_enabled }
  end
  describe ssl(host:'localhost',port:8443).protocols('tls1.0') do
    it { should_not be_enabled }
  end
  describe ssl(host:'localhost',port:8443).protocols('tls1.1') do
    it { should_not be_enabled }
  end
  describe ssl(host:'localhost',port:8443).protocols('tls1.2') do
    it { should be_enabled }
  end
  describe package('nginx') do
    it {should be_installed}
    its('version') { should include('1.12.1') }
  end
  describe ssl(host:'localhost',port: 8443).ciphers(/WITH_RC4/i) do
    it { should_not be_enabled }
  end
  describe http('https://localhost:8443', ssl_verify:false) do
    its('status') { should cmp 200 }
    its('body') { should include('Ubuntu') }
    its('body') { should include('16.04') }
    its('body') { should include('13') }
  end
end