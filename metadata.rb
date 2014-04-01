name             "base"
maintainer       "NewMedia! Denver"
maintainer_email "support@newmediadenver.com"
license          "Apache 2.0"
description      "Sets up base components common to all NewMedia Servers"
version          "0.0.1"
recipe           "base::default", "Enables the chef-client service on a schedule in addition to each of the other recipes in this cookbook."
recipe           "base::ldap", "Installs and configures ldap pam authentication."
recipe           "base::yubico", "Installs and configures yubico pam authentication."

depends 'chef-client'
depends 'apt'
depends 'openssh'
depends 'fail2ban'
