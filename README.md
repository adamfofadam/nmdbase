
NewMedia! Denver's nmdbase cookbook
=============================

nmdbase (1.0.6) Manages ldap client, yubico pam, ssl certificates and unattended updates.

This is a base cookbook for all NewMedia Denver servers. It contains core functionality necessary for standardized integration into our broader systems. In the spirit of open source, we are going to illustrate how to properly craft, and deliver, fantastically reliable and secure infrastructure.We use this recipe to enable two factor authentication for ssh accounts. The first factor is a plain text password the user knows. The second is a YubiKey usb hardware device. The instance is configured to create a new linux account on the machine if both factors authenticate. We also use this recipe to install fail2ban to protect against repeated ssh failures and ssh ddos attacks. The final task performed by this recipe is to enable the instance as a chef client so that it is regularly checking in with our chef servers. Test kitchen is configured to expect that the environment variable DATA_BAGS_PATH be set.  To use the example databags set DATA_BAGS_PATH to test/integration/data_bags/ ie export DATA_BAGS_PATH=test/integration/data_bags/ and set use_encrypted_databags to :no.

Requirements
------------

### Platforms

`ubuntu >= 14.04`

`centos >= 6.0`

### Dependencies

`chef-client >= 0.0.0`

`apt >= 0.0.0`

`openssh >= 0.0.0`

`fail2ban >= 0.0.0`


Attributes
----------

    

Recipes
-------

    nmdbase::default: Enables the chef-client service on a schedule in addition to each of the other recipes in this cookbook.
    nmdbase::ldap: Installs and configures ldap pam authentication.
    nmdbase::ssl: Manages the organization specific ssl certificates.
    nmdbase::yubico: Installs and configures yubico pam authentication.
    

Testing and Utility
-------

    rake foodcritic                                  # Lint Chef cookbooks
    rake integration                                 # Alias for kitchen:all
    rake kitchen:all                                 # Run all test instances
    rake kitchen:default-centos-65-virtualbox        # Run default-centos-65-virtualbox test instance
    rake kitchen:default-centos-65-vmware            # Run default-centos-65-vmware test instance
    rake kitchen:default-ubuntu-1404-virtualbox      # Run default-ubuntu-1404-virtualbox test instance
    rake kitchen:default-ubuntu-1404-vmware          # Run default-ubuntu-1404-vmware test instance
    rake kitchen:ldap-centos-65-virtualbox           # Run ldap-centos-65-virtualbox test instance
    rake kitchen:ldap-centos-65-vmware               # Run ldap-centos-65-vmware test instance
    rake kitchen:ldap-ubuntu-1404-virtualbox         # Run ldap-ubuntu-1404-virtualbox test instance
    rake kitchen:ldap-ubuntu-1404-vmware             # Run ldap-ubuntu-1404-vmware test instance
    rake kitchen:yubico-centos-65-virtualbox         # Run yubico-centos-65-virtualbox test instance
    rake kitchen:yubico-centos-65-vmware             # Run yubico-centos-65-vmware test instance
    rake kitchen:yubico-ldap-centos-65-virtualbox    # Run yubico-ldap-centos-65-virtualbox test instance
    rake kitchen:yubico-ldap-centos-65-vmware        # Run yubico-ldap-centos-65-vmware test instance
    rake kitchen:yubico-ldap-ubuntu-1404-virtualbox  # Run yubico-ldap-ubuntu-1404-virtualbox test instance
    rake kitchen:yubico-ldap-ubuntu-1404-vmware      # Run yubico-ldap-ubuntu-1404-vmware test instance
    rake kitchen:yubico-ubuntu-1404-virtualbox       # Run yubico-ubuntu-1404-virtualbox test instance
    rake kitchen:yubico-ubuntu-1404-vmware           # Run yubico-ubuntu-1404-vmware test instance
    rake readme                                      # Generate the Readme.md file
    rake rubocop                                     # Run RuboCop style and lint checks
    rake spec[os]                                    # Run ChefSpec examples
    rake test                                        # Run all tests


License and Authors
------------------

The following users have contributed to this code:
  * [David Arnold](https://github.com/DavidXArnold)
  * [Kevin Bridges](https://github.com/cyberswat)
  * [Brandon Williams](https://github.com/bw411)



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
