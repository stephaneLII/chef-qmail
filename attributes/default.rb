
default['qmail']['src_packager'] = '/usr/local/src'
default['qmail']['qmail_home'] = '/var/qmail'
default['qmail']['qmail_log'] = '/var/log/qmail'
default['qmail']['qmail_service'] = '/service'
default['qmail']['qmail_bals'] = '/data/mail'
default['qmail']['courier_etc'] = '/etc/courier'

default['qmail']['ldapuid'] = '1007'
default['qmail']['ldapgid'] = '104'
default['qmail']['ldapserver'] = 'localhost'
default['qmail']['ldapbasedn'] = 'dc=example'
default['qmail']['ldaplogin'] = "cn=manager,#{node['qmail']['ldapbasedn']}"
default['qmail']['ldapgrouplogin'] = "cn=manager,#{node['qmail']['ldapbasedn']}"
default['qmail']['ldappassword'] = 'password'
default['qmail']['ldapgrouppassword'] = 'password'
default['qmail']['ldaplocaldelivery'] = 0
default['qmail']['ldapobjectclass'] = 'qmailUser'
default['qmail']['ldaprebind'] = 1

default['qmail']['imapd_install'] = true
default['qmail']['imapd_enable'] = false
default['qmail']['pop3d_enable'] = false

default['qmail']['me'] = 'localhost'
default['qmail']['defaultdelivery'] = './Maildir/'
default['qmail']['concurrencyincoming'] = 300
default['qmail']['concurrencremote'] = 300
default['qmail']['concurrentcylocal'] = 300
default['qmail']['databytes'] = 10485760
default['qmail']['create_homedir'] = 'create_homedir'
default['qmail']['dirmaker'] = "#{node['qmail']['qmail_home']}/bin/#{node['qmail']['create_homedir']}"
default['qmail']['locals'] = ['localhost']
default['qmail']['rcpthosts'] = ['localhost']
default['qmail']['smtproutes'] = [':localhost']
default['qmail']['pop3drules'] = ['']
default['qmail']['smtpdrules'] = ['']