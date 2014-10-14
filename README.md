# chef-qmail

This cookbook install and configure a mail transport agent based on Qmail with LDAP support.

It can :
*installs courier-imapd and enable pop3d, imapd service on the fly.

## Supported Platforms

* Ubuntu 12.04 LTS
* Ubuntu 14.04 LTS

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['qmail']['src_packager']</tt></td>
    <td>String</td>
    <td>source directory</td>
    <td><tt>/usr/local/src</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['qmail_home']</tt></td>
    <td>String</td>
    <td>install directory</td>
    <td><tt>/var/qmail</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['qmail_log']</tt></td>
    <td>String</td>
    <td>logs directory</td>
    <td><tt>/var/log/qmail</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['qmail_service']</tt></td>
    <td>String</td>
    <td>services directory</td>
    <td><tt>/service</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['qmail_bals']</tt></td>
    <td>String</td>
    <td>mail directory</td>
    <td><tt>/data/mail</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['courier_etc']</tt></td>
    <td>String</td>
    <td>imap directory</td>
    <td><tt>/etc/courier</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['remove_package_mtas']</tt></td>
    <td>Array of string</td>
    <td>MTAs's package to remove</td>
    <td><tt>['sendmail', 'exim4-base', 'exim4-config', 'exim4-daemon-light' ]</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['remove_package_mtas']></td>
    <td>Array of string</td>
    <td>MTAs's service to disable</td>
    <td><tt>['sendmail', 'exim4' ]</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['ldapuid']</tt></td>
    <td>String</td>
    <td>virtual user uid</td>
    <td><tt>1007</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['ldapgid']</tt></td>
    <td>String</td>
    <td>virtual group uid</td>
    <td><tt>104</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['ldapserver']</tt></td>
    <td>String</td>
    <td>ldap server</td>
    <td><tt>localhost</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['ldapbasedn']</tt></td>
    <td>String</td>
    <td>ldap base dn</td>
    <td><tt>dc=example</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['ldaplogin']</tt></td>
    <td>String</td>
    <td>ldap user login</td>
    <td><tt>cn=manager,dc=example</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['ldapgrouplogin']</tt></td>
    <td>String</td>
    <td>ldap group login</td>
    <td><tt>cn=manager,dc=example</tt></td>
   </tr>
   <tr>
    <td><tt>['qmail']['ldappassword']</tt></td>
    <td>String</td>
    <td>ldap password</td>
    <td><tt>password</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['ldapgrouppassword']</tt></td>
    <td>String</td>
    <td>ldap group password</td>
    <td><tt>password</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['ldaplocaldelivery']</tt></td>
    <td>String</td>
    <td>ldap local delivery</td>
    <td><tt>0</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['ldapobjectclass']</tt></td>
    <td>String</td>
    <td>ldap object Class</td>
    <td><tt>qmailUser</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['ldaprebind']</tt></td>
    <td>String</td>
    <td>ldap rebind</td>
    <td><tt>1</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['imapd_install']</tt></td>
    <td>boolean</td>
    <td>Install courier-imapd</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['imapd_enable']</tt></td>
    <td>boolean</td>
    <td>Enable courier-mapd</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['pop3d_enable']</tt></td>
    <td>boolean</td>
    <td>enable qmail-pop3d</td>
    <td><tt>false</tt></td>
  </tr>

  <tr>
    <td><tt>['qmail']['me']</tt></td>
    <td>string</td>
    <td>default for many control files </td>
    <td><tt>localhost</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['defaultdelivery']</tt></td>
    <td>string</td>
    <td>Mail format box</td>
    <td><tt>./Maildir/</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['concurrencyincoming']</tt></td>
    <td>integer</td>
    <td>max simultaneous incoming SMTP connections</td>
    <td><tt>300</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['concurrencyremote']</tt></td>
    <td>integer</td>
    <td>max simultaneous remote deliveries </td>
    <td><tt>300</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['concurrencylocal']</tt></td>
    <td>integer</td>
    <td>max simultaneous local deliveries</td>
    <td><tt>300</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['databytes']</tt></td>
    <td>integer</td>
    <td>max number of bytes in message (0=no limit)</td>
    <td><tt>10485760</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['locals']</tt></td>
    <td>Array of strings</td>
    <td>domains that we deliver locally </td>
    <td><tt>me</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['rcpthosts']</tt></td>
    <td>Array of strings</td>
    <td>domains that we accept mail for</td>
    <td><tt>me</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['smtproutes']</tt></td>
    <td>Array of string</td>
    <td>artificial SMTP routes </td>
    <td><tt>none</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['pop3drules']</tt></td>
    <td>Array of string</td>
    <td>TcpRules for pop3d tcpserver</td>
    <td><tt>none</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['smtpdrules']</tt></td>
    <td>Array of string</td>
    <td>TcpRules for smtpd tcpserver</td>
    <td><tt>none</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['create_homedir']</tt></td>
    <td>string</td>
    <td>script for creating directory</td>
    <td><tt>create_homedir</tt></td>
  </tr>
  <tr>
    <td><tt>['qmail']['dirmaker']</tt></td>
    <td>string</td>
    <td>Provider script for creating directory</td>
    <td><tt>#{node['qmail']['qmail_home']}/bin/#{node['qmail']['create_homedir']}</tt></td>
  </tr>
</table>


## Usage

### chef-qmail::default

Include `chef-qmail` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[chef-qmail::default]"
  ]
}
```

## License and Authors

Author : DSI (<stephane.lii@informatique.gov.pf>)
