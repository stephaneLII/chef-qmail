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
# Paquets necessaires pour QMAIL
##################################

node['qmail']['remove_service_mtas'].each do |pkg|
  service pkg do
    puts "/etc/init.d/#{pkg}"
      supports status: true, restart: true, stop: true, reload: true
      action [:disable, :stop]
      only_if { ::File.exists?("/etc/init.d/#{pkg}") }
    end
end

node['qmail']['remove_package_mtas'].each do |pkg|
  package pkg do
    action :purge
  end
end

%w( gcc tar csh ucspi-tcp daemontools daemontools-run libldap2-dev libssl-dev git-core ).each do |pkg|
  package pkg do
    action :install
  end
end

if node['qmail']['imapd_install'] then
   include_recipe "chef-qmail::courier-imapd"
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
# Creation des répertoires de base
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
# Download + Compilation de qmail + qmail-ldap
##################################
config_fast_command = "config-fast #{node['qmail']['me']}"

bash 'download-compilation-qmail-src-ldap' do
  user 'root'
  cwd node['qmail']['src_packager']
  code <<-EOH
  git clone  https://github.com/stephaneLII/qmail-src-ldap.git
  cd qmail-src-ldap
  make setup check
  ./#{config_fast_command}
  EOH
end

##################################
# Creation du script de controle qmailctl
##################################

template "#{qmail_home}/bin/qmailctl" do
  source 'qmailctl.erb'
  owner 'root'
  group 'qmail'
  mode '0755'
  variables(
    :pop3d => node['qmail']['pop3d_enable'],
    :qmail_home => node['qmail']['qmail_home']
    )
end

link '/usr/bin/qmailctl' do
  to "#{qmail_home}/bin/qmailctl"
end

###############################################
# Paramétrage de qmail
###############################################

template "#{qmail_home}/control/defaultdelivery" do
  source 'defaultdelivery.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template "#{qmail_home}/control/concurrencyincoming" do
  source 'concurrencyincoming.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template "#{qmail_home}/control/concurrencyremote" do
  source 'concurrencyremote.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template "#{qmail_home}/control/concurrencylocal" do
  source 'concurrencylocal.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template "#{qmail_home}/boot/qmail-smtpd/run" do
  source 'qmail-smtpd.run.erb'
  owner 'root'
  group 'qmail'
  mode '0755'
  action :create
end


template "#{qmail_home}/control/databytes" do
  source 'databytes.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template "#{qmail_home}/control/locals" do
  source 'locals.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :locals => node['qmail']['locals']
    )
end

template "#{qmail_home}/control/rcpthosts" do
  source 'rcpthosts.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :rcpthosts => node['qmail']['rcpthosts']
    )
end

template "#{qmail_home}/control/smtproutes" do
  source 'smtproutes.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :smtproutes => node['qmail']['smtproutes']
    )
end

template "#{qmail_home}/control/qmail-pop3d.rules" do
  source 'qmail-pop3d.rules.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :pop3ds => node['qmail']['pop3drules']
    )
end

template "#{qmail_home}/control/qmail-smtpd.rules" do
  source 'qmail-smtpd.rules.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :smtpds => node['qmail']['smtpdrules']
    )
end

template "#{qmail_home}/control/dirmaker" do
  source 'dirmaker.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template "#{qmail_home}/alias/.qmail-root" do
  source 'qmail-root'
  owner 'root'
  group 'qmail'
  mode '0644'
end

template "#{qmail_home}/alias/.qmail-postmaster" do
  source 'qmail-postmaster'
  owner 'root'
  group 'qmail'
  mode '0644'
end

template "#{qmail_home}/alias/.qmail-mailer-daemon" do
  source 'dqmail-mailer-daemon'
  owner 'root'
  group 'qmail'
  mode '0644'
end

cookbook_file 'create_homedir' do
  path "/var/qmail/bin/create_homedir"
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

###############################################
# Paramétrage des accès au LDAP
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

template "#{qmail_home}/control/ldapuid" do
  source 'ldapuid.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template "#{qmail_home}/control/ldapgid" do
  source 'ldapgid.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template "#{qmail_home}/control/ldaplocaldelivery" do
  source 'ldaplocaldelivery.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template "#{qmail_home}/control/ldapobjectclass" do
  source 'ldapobjectclass.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template "#{qmail_home}/control/ldaprebind" do
  source 'ldaprebind.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

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

link '/usr/lib/sendmail' do
  to '/var/qmail/bin/sendmail'
end

###############################################
# Activation/désactivation du service pop3d si node['qmail']['pop3d_enable']
###############################################

if node['qmail']['pop3d_enable'] then
  link "#{qmail_service}/qmail-pop3d" do
     to "#{qmail_home}/boot/qmail-pop3d"
  end
else
  link "#{qmail_service}/qmail-pop3d" do
     to "#{qmail_home}/boot/qmail-pop3d"
     action :delete
  end
end


###############################################
# Redémarrage du service Qmail selon ubuntu 14.04
###############################################

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
