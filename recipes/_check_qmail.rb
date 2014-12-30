#
# Cookbook Name:: qmail
# Recipe:: _check_qmail
#
# Copyright (C) 2014 DSI
#
# All rights reserved - Do Not Redistribute
#

%w(ruby ruby-dev).each do |pkg|
  package pkg do
    action :install
  end
end

%w(sensu-plugin).each do |pkg|
  gem_package pkg do
    action :install
  end
end

directory "/etc/sensu/plugins" do
  owner "sensu"
  group "sensu"
  mode "0750"
  recursive true
  action :create
end

cookbook_file "/etc/sensu/plugins/check-qmailq.rb" do
  source "check-qmailq.rb"
  owner "root"
  group "root"
  mode "0755"
end
