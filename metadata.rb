name             "base"
maintainer       "NewMedia! Denver"
maintainer_email "support@newmediadenver.com"
license          "Apache 2.0"
description      "Installs/configures something"
version          "0.0.1"
recipe           "base::default", "Installs/configures something"

depends 'chef-client'
depends 'fail2ban'
depends 'sudo'
depends 'openssh'
#depends 'hostname'