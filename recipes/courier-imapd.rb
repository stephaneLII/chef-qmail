#
# Cookbook Name:: chef-qmail
# Recipe:: courier-imapd
#
# Copyright (C) 2014 DSI
#
# All rights reserved - Do Not Redistribute
#

courier_etc = node['qmail']['courier_etc']
 puts "   \033[31mINSTALLING IMAP\033[0m\n"
##################################
# Paquets necessaires
##################################

%w( debconf-utils ).each do |pkg|
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
# Courier-imap Packages
###############################

%w( courier-authdaemon courier-authlib courier-authlib-ldap courier-ldap courier-imap ).each do |pkg|
  package pkg do
    action :install
  end
end

service 'postfix' do
  supports status: true, restart: true, stop: true, reload: true
  action [:disable, :stop]
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
  supports restart: true, reload: true , stop: true
  action [:nothing]
end

service 'courier-authdaemon' do
  supports restart: true, reload: true, stop: true
  action [:nothing]
end

service 'courier-imap' do
  supports restart: true, reload: true, stop: true
  action [:nothing]
end

if ! node['qmail']['imapd_enable'] then
  
  puts "   \033[31mDISABLING\033[0m\n"
  bash 'Courier-stop' do
    user 'root'
    code <<-EOH
      service courier-ldap stop ; service courier-authdaemon stop ; service courier-imap stop
    EOH
  end
end

#; service courier-authdaemon stop ; service courier-imap stop
if node['qmail']['imapd_enable'] then
  
  puts "   \033[31mDISABLING\033[0m\n"
  bash 'Courier-start' do
    user 'root'
    code <<-EOH
      service courier-ldap start ; service courier-authdaemon start ; service courier-imap start
    EOH
  end
end