# encoding: utf-8
name 'nmdbase'
maintainer 'NewMedia! Denver'
maintainer_email 'support@newmediadenver.com'
license 'Apache 2.0'

version '1.0.7'
supports 'ubuntu', '>= 14.04'
supports 'centos', '>= 6.0'

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
desc << 'servers. Test kitchen is configured to expect that the environment'
desc << ' variable DATA_BAGS_PATH be set.  To use the example databags '
desc << 'set DATA_BAGS_PATH to test/integration/data_bags/ ie'
desc << ' export DATA_BAGS_PATH=test/integration/data_bags/ and set '
desc << 'use_encrypted_databags to :no.'
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

#provides 'nmdbase::iptables'
desc = 'Configures iptables.  Uses the recipe '
desc << 'simple_iptables https://github.com/rtkwlf/cookbook-simple-iptables '
desc << ' to manage rules / polices. '
desc << ' example: '
desc << ' "nmdbase": {'
desc << '           "simple_iptables_policy": {'
desc << '             "policy 1": {'
desc << '               "name": "INPUT",'
desc << '               "table": "nat",'
desc << '               "defined_policy": "ACCEPT"'
desc << '             }'
desc << '           },'
desc << '           "simple_iptables_rules": {'
desc << '             "rule 1": {'
desc << '               "name": "icmp",'
desc << '               "chain": "INPUT",'
desc << '               "rule": "--proto icmp",'
desc << '               "jump": "ACCEPT",'
desc << '               "weight": 2'
desc << '             }'
desc << '           }'
desc << '         }'

recipe 'nmdbase::iptables', desc

depends 'chef-client'
depends 'apt'
depends 'openssh'
depends 'fail2ban'
depends 'simple_iptables'
