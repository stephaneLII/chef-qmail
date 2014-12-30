#
# Cookbook Name:: qmail
# Recipe:: courier-imapd
#
# Copyright (C) 2014 DSI
#
# All rights reserved - Do Not Redistribute
#

courier_etc = node['qmail']['courier_etc']

##################################
# Paquets necessaires pour debconf
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

##################################
# We ensure other MTAs are remove and disabled after installing courier-imap
##################################

node['qmail']['remove_service_mtas'].each do |pkg|
  service pkg do
      supports status: true, restart: true, stop: true, reload: true
      action [:disable, :stop]
      only_if { ::File.exists?("/etc/init.d/#{pkg}") }
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

if ! node['qmail']['imapd_enable'] then 
#  puts "   \033[31mDISABLING\033[0m\n"
  bash 'Courier-stop' do
    user 'root'
    code <<-EOH
      update-rc.d courier-ldap disable ; update-rc.d courier-authdaemon disable ; update-rc.d courier-imap disable
      service courier-ldap stop ; service courier-authdaemon stop ; service courier-imap stop
    EOH
  end
end

if node['qmail']['imapd_enable'] then
#  puts "   \033[31mENABLING\033[0m\n"
  bash 'Courier-start' do
    user 'root'
    code <<-EOH
      update-rc.d courier-ldap enable ; update-rc.d courier-authdaemon enable ; update-rc.d courier-imap enable 
      service courier-ldap start ; service courier-authdaemon start ; service courier-imap start
    EOH
  end
end
