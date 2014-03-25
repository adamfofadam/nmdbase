name             "base"
maintainer       "NewMedia! Denver"
maintainer_email "support@newmediadenver.com"
license          "Apache 2.0"
description      "Sets up base components common to all NewMedia Servers"
version          "0.0.1"
recipe           "base::default", "Installs/configures something"

depends 'chef-client'
depends 'apt'
depends 'openssh'
