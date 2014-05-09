# encoding: utf-8
name 'nmdbase'
maintainer 'NewMedia! Denver'
maintainer_email 'support@newmediadenver.com'
license 'Apache 2.0'

version '1.0.1'
supports 'ubuntu', '= 12.04'
supports 'ubuntu', '= 14.04'

desc = 'Manages ldap client, yubico pam, ssl certificates and unattended '
desc << 'updates.'
description desc

desc = 'Acts as a base recipe for chef-client and security components '
desc << '(ldap/yubikey two factor authentication).'

desc = 'This is a base cookbook for all NewMedia Denver servers. It contains '
desc << 'core functionality necessary for standardized integration into our '
desc << 'broader systems. In the spirit of open source, we are going to '
desc << 'illustrate how to properly craft, and deliver, fantastically '
desc << 'reliable and secure infrastructure.'

desc << 'We use this recipe to enable two factor authentication for ssh '
desc << 'accounts. The first factor is a plain text password the user knows. '
desc << 'The second is a YubiKey usb hardware device. The instance is '
desc << 'configured to create a new linux account on the machine if both '
desc << 'factors authenticate. We also use this recipe to install fail2ban to '
desc << 'protect against repeated ssh failures and ssh ddos attacks. The '
desc << 'final task performed by this recipe is to enable the instance as a '
desc << 'chef client so that it is regularly checking in with our chef '
desc << 'servers.'
long_description desc

desc = 'Enables the chef-client service on a schedule in addition to each of '
desc << 'the other recipes in this cookbook.'
recipe 'nmdbase::default', desc

provides 'nmdbase::ldap'
recipe 'nmdbase::ldap', 'Installs and configures ldap pam authentication.'

provides 'nmdbase::ssl'
recipe 'nmdbase::ssl', 'Manages the organization specific ssl certificates.'

provides 'nmdbase::yubico'
recipe 'nmdbase::yubico', 'Installs and configures yubico pam authentication.'

depends 'chef-client'
depends 'apt'
depends 'openssh'
depends 'fail2ban'
