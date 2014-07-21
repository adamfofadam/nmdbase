NewMedia! Denver's nmdbase cookbook
=============================

nmdbase (1.0.9) Manages ldap client, yubico pam, ssl certificates and unattended updates.

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

`simple_iptables >= 0.0.0`

`logwatch >= 0.0.0`

`postfix >= 0.0.0`


Attributes
----------


Recipes
-------

    nmdbase::default
      Enables the chef-client service on a schedule in addition to each of the other recipes in this cookbook.

    nmdbase::ldap
      Installs and configures ldap pam authentication.

    nmdbase::ssl
      Manages the organization specific ssl certificates.

    nmdbase::yubico
      Installs and configures yubico pam authentication.

    nmdbase::iptables
      Configures iptables.  Uses the recipe simple_iptables https://github.com/rtkwlf/cookbook-simple-iptables  to manage rules / polices.  example:  "nmdbase": {           "simple_iptables_policy": {             "policy 1": {               "name": "INPUT",               "table": "nat",               "defined_policy": "ACCEPT"             }           },           "simple_iptables_rules": {             "rule 1": {               "name": "icmp",               "chain": "INPUT",               "rule": "--proto icmp",               "jump": "ACCEPT",               "weight": 2             }           }         }

Testing and Utility
-------
    <Rake::Task default => [test]>

    <Rake::Task foodcritic => []>
      Run Foodcritic lint checks

    <Rake::Task integration => [kitchen:all]>
      Alias for kitchen:all

    <Rake::Task kitchen:all => [default-ubuntu-1404-vmware, default-ubuntu-1404-virtualbox, default-centos-65-vmware, default-centos-65-virtualbox, ldap-ubuntu-1404-vmware, ldap-ubuntu-1404-virtualbox, ldap-centos-65-vmware, ldap-centos-65-virtualbox, yubico-ubuntu-1404-vmware, yubico-ubuntu-1404-virtualbox, yubico-centos-65-vmware, yubico-centos-65-virtualbox, yubico-ldap-ubuntu-1404-vmware, yubico-ldap-ubuntu-1404-virtualbox, yubico-ldap-centos-65-vmware, yubico-ldap-centos-65-virtualbox]>
      Run all test instances

    <Rake::Task kitchen:default-centos-65-virtualbox => []>
      Run default-centos-65-virtualbox test instance

    <Rake::Task kitchen:default-centos-65-vmware => []>
      Run default-centos-65-vmware test instance

    <Rake::Task kitchen:default-ubuntu-1404-virtualbox => []>
      Run default-ubuntu-1404-virtualbox test instance

    <Rake::Task kitchen:default-ubuntu-1404-vmware => []>
      Run default-ubuntu-1404-vmware test instance

    <Rake::Task kitchen:ldap-centos-65-virtualbox => []>
      Run ldap-centos-65-virtualbox test instance

    <Rake::Task kitchen:ldap-centos-65-vmware => []>
      Run ldap-centos-65-vmware test instance

    <Rake::Task kitchen:ldap-ubuntu-1404-virtualbox => []>
      Run ldap-ubuntu-1404-virtualbox test instance

    <Rake::Task kitchen:ldap-ubuntu-1404-vmware => []>
      Run ldap-ubuntu-1404-vmware test instance

    <Rake::Task kitchen:yubico-centos-65-virtualbox => []>
      Run yubico-centos-65-virtualbox test instance

    <Rake::Task kitchen:yubico-centos-65-vmware => []>
      Run yubico-centos-65-vmware test instance

    <Rake::Task kitchen:yubico-ldap-centos-65-virtualbox => []>
      Run yubico-ldap-centos-65-virtualbox test instance

    <Rake::Task kitchen:yubico-ldap-centos-65-vmware => []>
      Run yubico-ldap-centos-65-vmware test instance

    <Rake::Task kitchen:yubico-ldap-ubuntu-1404-virtualbox => []>
      Run yubico-ldap-ubuntu-1404-virtualbox test instance

    <Rake::Task kitchen:yubico-ldap-ubuntu-1404-vmware => []>
      Run yubico-ldap-ubuntu-1404-vmware test instance

    <Rake::Task kitchen:yubico-ubuntu-1404-virtualbox => []>
      Run yubico-ubuntu-1404-virtualbox test instance

    <Rake::Task kitchen:yubico-ubuntu-1404-vmware => []>
      Run yubico-ubuntu-1404-vmware test instance

    <Rake::Task readme => []>
      Generate the Readme.md file.

    <Rake::Task rubocop => []>
      Run RuboCop style and lint checks

    <Rake::Task rubocop:auto_correct => []>
      Auto-correct RuboCop offenses

    <Rake::Task spec => []>
      Run ChefSpec examples. Specify OS to test either with rake "spec[rhel]" (Redhat,centos etc) or rake "spec[ubuntu]". Defaults to both

    <Rake::Task test => [rubocop, foodcritic, spec, integration]>
      Run all tests

License and Authors
------------------

The following engineers have contributed to this code:
 * [Kevin Bridges](https://github.com/cyberswat) - 139 commits
 * [David Arnold, DavidXArnold](https://github.com/DavidXArnold) - 95 commits
 * [Making GitHub Delicious.](https://github.com/waffle-iron) - 1 commits
 * [Brandon Williams](https://github.com/bw411) - 9 commits

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
