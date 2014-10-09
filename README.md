# chef-qmail

This cookbook install and configure a mail transport agent based on Qmail with LDAP support.

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
