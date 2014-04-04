[![Build Status](https://travis-ci.org/newmediadenver/nmdbase.svg?branch=master)](https://travis-ci.org/newmediadenver/nmdbase) [![Coverage Status](https://coveralls.io/repos/newmediadenver/nmdbase/badge.png?branch=master)](https://coveralls.io/r/newmediadenver/nmdbase?branch=master) [![Dependency Status](https://gemnasium.com/newmediadenver/nmdbase.svg)](https://gemnasium.com/newmediadenver/nmdbase)

NewMedia Denver Base Cookbook
=================

This is a base cookbook for all NewMedia Denver servers. It contains core
functionality necessary for standardized integration into our broader systems.
In the spirit of open source, we are going to illustrate how to properly craft,
and deliver, fantastically reliable and secure infrastructure.

We use this recipe to enable two factor authentication for ssh accounts.  The
first factor is a plain text password the user knows. The second is a YubiKey
usb hardware device.  The instance is configured to create a new linux account
on the machine if both factors authenticate. We also use this recipe to install
fail2ban to protect against repeated ssh failures and ssh ddos attacks.  The
final task performed by this recipe is to enable the instance as a chef client
so that it is regularly checking in with our chef servers.

The base boxes that we use are stored in s3 and referenced from the kitchen.yml.

Requirements
------------

### Platform:

`ubuntu-12.04`

### Cookbooks:

    depends 'chef-client'
    depends 'apt'
    depends 'openssh'
    depends 'fail2ban'

Attributes
----------

### nmdbase::default

No attributes.

### nmdbase::ldap

    # An array of LDAP configuration options to enable the node as a LDAP client.
    default['nmdbase']['ldap']['conf'] = [
      'base dc=ldap,dc=example,dc=com',
      'uri ldap://ldap.example.com/',
      'ldap_version 3',
      'rootbinddn cn=admin,dc=ldap,dc=example,dc=com',
      'pam_password md5'
    ]
    default['nmdbase']['ldap']['path'] = '/etc/ldap.conf'
    # The location of the ldap secret file. The password is stored in the "secret"
    # key of data_bags/users/ldap
    default['nmdbase']['ldap']['secret'] = '/etc/ldap.secret'

    # Manage nsswitch here to enable LDAP.
    default['nmdbase']['nsswitch'] = '/etc/nsswitch.conf'
    # An array of LDAP configuration options to enable the node as a LDAP client.
    default['nmdbase']['nsswitch_config'] = [
      'passwd: ldap compat',
      'group: ldap compat',
      'shadow: ldap compat',
      'hosts: files dns',
      'networks: files',
      'protocols: db files',
      'services: db files',
      'ethers: db files',
      'rpc: db files',
      'netgroup: nis'
    ]

    # Modify the PAM common-session to create user system accounts from LDAP data.
    default['nmdbase']['common_session'] = '/etc/pam.d/common-session'
    default['nmdbase']['common_session_confg'] = [
      'session [default=1] pam_permit.so',
      'session requisite pam_deny.so',
      'session required pam_permit.so',
      'session optional pam_umask.so',
      'session required pam_unix.so',
      'session optional pam_ldap.so',
      'session required pam_mkhomedir.so skel=/etc/skel umask=0022'
    ]


### nmdbase::yubico

    # An array of PAM sshd configuration options that should include enabling
    # pam_yubico.so
    default['nmdbase']['pam']['sshd']['conf'] = [
      # Activate pam_yubico.so as the first item. If you create
      # data_bags/users/yubico.json with your "key" and "id" from
      # https://upgrade.yubico.com/getapikey/ it will be added to this string.
      # Otherwise, you will need to add the id and key to this string.  There is an
      # example of LDAP integration in the default suite of .kitchen.yml
      'auth required pam_yubico.so mode=client try_first_pass authfile=/etc/yubikey_mappings debug',
      # Standard Un*x authentication.
      '@include common-auth',
      # Disallow non-root logins when /etc/nologin exists.
      'account    required     pam_nologin.so',
      # Standard Un*x authorization.
      '@include common-account',
      # Standard Un*x session setup and teardown.
      '@include common-session',
      # Print the message of the day upon successful login.
      'session    optional     pam_motd.so # [1]',
      # Print the status of the user's mailbox upon successful login.
      'session    optional     pam_mail.so standard noenv # [1]',
      # Set up user limits from /etc/security/limits.conf.
      'session    required     pam_limits.so',
      # Read environment variables from /etc/environment and
      # /etc/security/pam_env.conf.
      'session    required     pam_env.so # [1]',
      # In Debian 4.0 (etch), locale-related environment variables were moved to
      # /etc/default/locale, so read that as well
      'session    required     pam_env.so user_readenv=1 envfile=/etc/default/locale',
      # Standard Un*x password updating.
      '@include common-password'
    ]
    # The path to the ssh PAM conf file.
    default['nmdbase']['pam']['sshd']['path'] = '/etc/pam.d/sshd'

    # Define yubikey mappings according to http://opensource.yubico.com/yubico-pam/
    # if validating yubikeys from a file and not LDAP.
    default['nmdbase']['yubico']['authfile'] = '/etc/yubikey_mappings'
    default['nmdbase']['yubico']['users'] = [
      'vagrant: cccccexample'
    ]


Recipes
-------

### nmdbase::default

Finishes establishing a server as a chef client by cleaning up residual
certificates and enabling the chef-client service to execute periodically.
Additionally, This enables the `nmdbase::ldap` and `nmdbase::yubico` recipes
providing a two factor solution backed by LDAP and YubiKey.

    nmdbase::default
      Includes the fail2ban recipe.
      Configures this instance as an LDAP client.
      Configures this instance as an Yubico API client.
      Configures this instance as a chef client.
      Configures the chef-client service.

### nmdbase::ldap

    nmdbase::ldap
      Installs the LDAP package to set this instance up as a client.
      Installs LDAP command line utilities.
      Configures the LDAP connection for this client.
      Installs the LDAP secret authentication content.
      Modifies the Name Service Switch to use LDAP.
      It configures the PAM common session to create users from LDAP.

### nmdbase::yubico

    nmdbase::yubico
      Includes the openssh recipe.
      Installs the openssh-client.
      Installs the openssh-server.
      Enables the ssh service.
      Starts the ssh service.
      Creates the ssh configuration.
      Creates the sshd configuration.
      Installs python-software-properties.
      Adds the yubico repositories.
      Notifies apt-get update when adding yubico repositories.
      Installs the libpam-yubico package from the yubico repositories.
      Creates a global yubico auth file.
      Configures the sshd PAM module.
      Prepares for PAM debug logging.

Requires yubikey authentication and password authentication to ssh into a
machine running this recipe.

We have implemented a basic set of functionality to meet our tests. The full
documentation, including how to generate values for the yubico attributes is
located at http://opensource.yubico.com/yubico-pam/.

At present, users yubikeys are recorded in a single file. The roadmap involves
switching this to LDAP.

Testing
-------

The cookbook provides the following Rake tasks for testing:

    rake foodcritic                       # Lint Chef cookbooks
    rake integration                      # Alias for kitchen:all
    rake kitchen:all                      # Run all test instances
    rake kitchen:default-ubuntu-1204      # Run default-ubuntu-1204 test instance
    rake kitchen:ldap-ubuntu-1204         # Run ldap-ubuntu-1204 test instance
    rake kitchen:yubico-ldap-ubuntu-1204  # Run yubico-ldap-ubuntu-1204 test instance
    rake kitchen:yubico-ubuntu-1204       # Run yubico-ubuntu-1204 test instance
    rake rubocop                          # Run RuboCop style and lint checks
    rake spec                             # Run ChefSpec examples
    rake test                             # Run all tests

License and Author
------------------

Author:: Kevin Bridges

Copyright:: 2014, NewMedia Denver

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Contributing
------------

We welcome contributed improvements and bug fixes via the usual workflow:

1. Fork this repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request
