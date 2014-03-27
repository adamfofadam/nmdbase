[![Build Status](https://magnum.travis-ci.com/newmediadenver/nmd-base.svg?token=xqpRxzbZzgHp6Va3MXGL&branch=master)](https://magnum.travis-ci.com/newmediadenver/nmd-base)

NewMedia Denver Base Cookbook
=================

This is the base recipe for all NewMedia servers. It contains core functionality
necessary for standardized integration into our broader systems.

Requirements
------------

### Platform:

`ubuntu-12.04`

### Cookbooks:

```
depends 'chef-client'
depends 'apt'
depends 'openssh'
```


Attributes
----------
```
default['base']['yubico']['id'] = "123456"
default['base']['yubico']['key'] = 'iqXJ1M4o70WCI2wrxBpn9qvGDiw='
default['base']['yubico']['authfile'] = '/etc/yubikey_mappings'
default['base']['yubico']['users'] = {
  'username' => 'ccccccritlul'
}
```
Recipes
-------

### base::default

Finishes establishing a server as a chef client by cleaning up residual
certificates and enabling the chef-client service to execute periodically.

### base::yubico

````
base::yubico
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
  Enables the yubico pam module.
````

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

```
rake foodcritic                   # Lint Chef cookbooks
rake integration                  # Alias for kitchen:all
rake kitchen:all                  # Run all test instances
rake kitchen:default-ubuntu-1204  # Run default-ubuntu-1204 test instance
rake kitchen:yubico-ubuntu-1204   # Run yubico-ubuntu-1204 test instance
rake rubocop                      # Run RuboCop style and lint checks
rake spec                         # Run ChefSpec examples
rake test                         # Run all tests
```

License and Author
------------------

Author:: Kevin Bridges kevin@newmediadenver.com

Copyright:: 2014, NewMedia! Denver

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

