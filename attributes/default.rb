
default['qmail']['src_packager'] = '/usr/local/src'
default['qmail']['qmail_home'] = '/var/qmail'
default['qmail']['qmail_log'] = '/var/log/qmail'
default['qmail']['qmail_service'] = '/service'
default['qmail']['qmail_bals'] = '/data/mail'
default['qmail']['ldapuid'] = '1007'
default['qmail']['ldapgid'] = '104'

default['qmail']['ldapserver'] = 'localhost'
default['qmail']['ldapbasedn'] = 'dc=example'
default['qmail']['ldaplogin'] = "cn=manager,#{node['qmail']['ldapbasedn']}"
default['qmail']['ldapgrouplogin'] = "cn=manager,#{node['qmail']['ldapbasedn']}"
default['qmail']['ldappassword'] = 'password'
default['qmail']['ldapgrouppassword'] = 'password'
