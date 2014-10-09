#
# Cookbook Name:: chef-qmail
# Recipe:: default
#
# Copyright (C) 2014 DSI
#
# All rights reserved - Do Not Redistribute
#

qmail_home = node['qmail']['qmail_home']
qmail_log = node['qmail']['qmail_log']
qmail_service = node['qmail']['qmail_service']
courier_etc = node['qmail']['courier_etc']

##################################
# Paquets necessaires
##################################

%w( debconf-utils gcc tar csh ucspi-tcp daemontools daemontools-run libldap2-dev libssl-dev git-core ).each do |pkg|
  package pkg do
    action :install
  end
end

cookbook_file 'courier-base.seed' do
  path '/tmp/courier-base.seed'
  action :create
  mode '0400'
  owner 'root'
end

cookbook_file 'postfix.seed' do
  path '/tmp/postfix.seed'
  action :create
  mode '0400'
  owner 'root'
end

bash 'setting-courier-base-options' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
   cat /tmp/courier-base.seed | debconf-set-selections
   cat /tmp/postfix.seed | debconf-set-selections
  EOH
end

###############################
# Courier-imap dependencies
###############################

%w( courier-authdaemon courier-authlib courier-authlib-ldap courier-ldap courier-imap ).each do |pkg|
  package pkg do
    action :install
  end
end

case node['platform']
when 'ubuntu'
  if node['platform_version'].to_f >= 14.04
    service 'postfix' do
      supports status: true, restart: true, stop: true, reload: true
      action [:disable, :stop]
    end
  end
end

template '/etc/courier/authldaprc' do
  source 'authldaprc.erb'
  owner 'daemon'
  group 'daemon'
  mode '0660'
  notifies :reload, 'service[courier-ldap]', :immediately
end

template 'authdaemonrc' do
  path "#{courier_etc}/authdaemonrc"
  source 'authdaemonrc.erb'
  mode '0660'
  notifies :reload, 'service[courier-authdaemon]', :immediately
end

template 'imapd' do
  path "#{courier_etc}/imapd"
  source 'imapd.erb'
  mode '0660'
  notifies :reload, 'service[courier-imap]', :immediately
end

service 'courier-ldap' do
  supports restart: true, reload: true
  action [:restart, :reload]
end

service 'courier-authdaemon' do
  supports restart: true, reload: true
  action [:restart, :reload]
end

service 'courier-imap' do
  supports restart: true, reload: true
  action [:restart, :reload]
end

##################################
# Creation des users and groups
##################################

group 'nofiles' do
  action :create
end

group 'vgroup' do
  gid node['qmail']['ldapgid']
  action :create
  non_unique true
end

group 'qmail' do
  action :create
end

user 'vuser' do
  gid 'vgroup'
  uid node['qmail']['ldapuid']
  home '/home/vuser'
  action :create
end

user 'alias' do
  gid 'nofiles'
  home '/var/qmail/alias'
  action :create
end

user 'qmaild' do
  gid 'nofiles'
  home '/var/qmail'
  action :create
end

user 'qmaill' do
  gid 'nofiles'
  home '/var/qmail'
  action :create
end

user 'qmailp' do
  gid 'nofiles'
  home '/var/qmail'
  action :create
end

user 'qmailq' do
  gid 'qmail'
  home '/var/qmail'
  action :create
end

user 'qmailr' do
  gid 'qmail'
  home '/var/qmail'
  action :create
end

user 'qmails' do
  gid 'qmail'
  home '/var/qmail'
  action :create
end

##################################
# Creation des repertoires de base
##################################

directory node['qmail']['src_packager'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory node['qmail']['qmail_log'] do
  owner 'qmaill'
  group 'root'
  mode '0755'
  action :create
end

directory "#{qmail_log}/smtpd" do
  owner 'qmaill'
  group 'root'
  mode '0755'
  action :create
end

directory node['qmail']['qmail_home'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory '/data' do
  owner 'root'
  group 'vgroup'
  mode '0775'
  action :create
end

directory node['qmail']['qmail_bals'] do
  owner 'vuser'
  group 'vgroup'
  mode '0700'
  action :create
end

##################################
# Compilation de qmail + qmail-ldap
##################################

bash 'download-compilation-qmail-src-ldap' do
  user 'root'
  cwd node['qmail']['src_packager']
  code <<-EOH
  git clone  https://github.com/stephaneLII/qmail-src-ldap.git
  cd qmail-src-ldap
  make setup check
  ./config-fast test.gov.pf
  EOH
end

##################################
# Download et compilation de courier-authlib
##################################
# bash 'download-courier-authlib' do
#  user 'root'
#  cwd node['qmail']['src_packager']
#  code <<-EOH
#  wget http://softlayer-dal.dl.sourceforge.net/project/courier/authlib/0.66.1/courier-authlib-0.66.1.tar.bz2
#  bunzip2 courier-authlib-0.66.1.tar.bz2
#  tar xvf courier-authlib-0.66.1.tar
#  cd courier-authlib-0.66.1
#  EOH
# end

##################################
# Download et compilation de courier-imap
##################################
# bash 'download-courier-imap' do
#  user 'root'
#  cwd node['qmail']['src_packager']
#  code <<-EOH
#  wget http://tcpdiag.dl.sourceforge.net/project/courier/imap/4.15.1/courier-imap-4.15.1.tar.bz2
#  bunzip2 courier-imap-4.15.1.tar.bz2
#  tar xvf courier-imap-4.15.1.tar
#  cd courier-imap-4.15.1
#  EOH
# end

##################################
# Creation de scripts controles
##################################
cookbook_file 'qmailctl' do
  path "#{qmail_home}/bin/qmailctl"
  action :create
  mode '0755'
end

link '/usr/bin/qmailctl' do
  to "#{qmail_home}/bin/qmailctl"
end

###############################################
# Parametrage de qmail
###############################################

cookbook_file 'defaultdelivery' do
  path "#{qmail_home}/control/defaultdelivery"
  action :create
  mode '0644'
end

cookbook_file 'concurrencyincoming' do
  path "#{qmail_home}/control/concurrencyincoming"
  action :create
  mode '0644'
end

cookbook_file 'qmail-smtpd.rules' do
  path "#{qmail_home}/control/qmail-smtpd.rules"
  action :create
  mode '0644'
end

cookbook_file 'qmail-pop3d.rules' do
  path "#{qmail_home}/control/qmail-pop3d.rules"
  action :create
  mode '0644'
end

cookbook_file 'qmail-imapd.rules' do
  path "#{qmail_home}/control/qmail-imapd.rules"
  action :create
  mode '0644'
end

cookbook_file 'rcpthosts' do
  path "#{qmail_home}/control/rcpthosts"
  action :create
  mode '0644'
end

cookbook_file 'locals' do
  path "#{qmail_home}/control/locals"
  action :create
  mode '0644'
end

###############################################
# Parametrage acces LDAP
###############################################

template "#{qmail_home}/control/ldapserver" do
  source 'ldapserver.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template "#{qmail_home}/control/ldapbasedn" do
  source 'ldapbasedn.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template "#{qmail_home}/control/ldaplogin" do
  source 'ldaplogin.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template "#{qmail_home}/control/ldapgrouplogin" do
  source 'ldapgrouplogin.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template "#{qmail_home}/control/ldappassword" do
  source 'ldappassword.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template "#{qmail_home}/control/ldapgrouppassword" do
  source 'ldapgrouppassword.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

cookbook_file 'ldapuid' do
  path "#{qmail_home}/control/ldapuid"
  action :create
  mode '0644'
end

cookbook_file 'ldapgid' do
  path "#{qmail_home}/control/ldapgid"
  action :create
  mode '0644'
end

cookbook_file 'ldaplocaldelivery' do
  path "#{qmail_home}/control/ldaplocaldelivery"
  action :create
  mode '0644'
end

cookbook_file 'ldapobjectclass' do
  path "#{qmail_home}/control/ldapobjectclass"
  action :create
  mode '0644'
end

cookbook_file 'ldaprebind' do
  path "#{qmail_home}/control/ldaprebind"
  action :create
  mode '0644'
end

cookbook_file 'dirmaker' do
  path "#{qmail_home}/control/dirmaker"
  action :create
  mode '0644'
end

cookbook_file 'create_homedir' do
  path "#{qmail_home}/bin/create_homedir"
  action :create
  mode '0775'
  group 'qmail'
end

bash 'MakeRules' do
  user 'root'
  cwd "#{qmail_home}/control"
  code <<-EOH
  make
  EOH
end

cookbook_file 'qmail-imap-run' do
  path "#{qmail_home}/boot/qmail-imapd/run"
  action :create
  mode '0755'
  group 'qmail'
end

# cookbook_file 'imapd' do
#  path "#{qmail_home}/bin/imapd"
#  action :create
#  mode '0755'
#  group 'qmail'
# end

# cookbook_file 'imaplogin' do
#  path "#{qmail_home}/bin/imaplogin"
#  action :create
#  mode '0755'
#  group 'qmail'
# end

###############################################
# Mise en place des liens symboliques
###############################################

link node['qmail']['qmail_service'] do
  to '/etc/service'
end

link "#{qmail_service}/qmail" do
  to "#{qmail_home}/boot/qmail"
end

link "#{qmail_service}/qmail-smtpd" do
  to "#{qmail_home}/boot/qmail-smtpd"
end

# link "#{qmail_service}/qmail-imapd" do
#  to "#{qmail_home}/boot/qmail-imapd"
# end

link "#{qmail_service}/qmail-pop3d" do
  to "#{qmail_home}/boot/qmail-pop3d"
end

link '/usr/local/bin/setuidgid' do
  to '/usr/bin/setuidgid'
end

link '/usr/local/bin/multilog' do
  to '/usr/bin/multilog'
end

link '/usr/local/bin/tcprules' do
  to '/usr/bin/tcprules'
end

link '/usr/local/bin/tcpserver' do
  to '/usr/bin/tcpserver'
end

link '/usr/local/bin/softlimit' do
  to '/usr/bin/softlimit'
end

link '/usr/local/bin/supervise' do
  to '/usr/bin/supervise'
end

link '/usr/local/bin/svok' do
  to '/usr/bin/svok'
end

link '/usr/local/bin/svscan' do
  to '/usr/bin/svscan'
end

link '/usr/local/bin/tai64nlocal' do
  to '/usr/bin/tai64nlocal'
end

case node['platform']
when 'ubuntu'
  start_command = 'initctl  stop svscan ; initctl   start svscan'
when 'debian'
  start_command = 'kill -HUP 1'
end

bash 'qmail-restart' do
  user 'root'
  cwd "#{qmail_home}/bin"
  code <<-EOH
    #{start_command}
  EOH
end
