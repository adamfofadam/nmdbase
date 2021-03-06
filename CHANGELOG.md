nmdbase CHANGELOG
====================

This file is used to list changes made in each version of the nmdbase
cookbook.

1.0.10 13-August-2014
-----
- [David Arnold] - Set iptables to reload vs restart.
1.0.9 14-July-2014
-----
- [David Arnold] - Added logwatch & postfix recipe to default and updated berksfile GEM version.
- 
1.0.8 7-July-2014
-----
- [David Arnold] - Changed rhel default nsswitch attribute.

1.0.7 1-July-2014
-----
- [David Arnold] - Added iptables recipe.

1.0.6 27-June-2014
-----
- [David Arnold] - Changed data bag encryption attribute to string vs symbol.

1.0.5 24-June-2014
-----
- [David Arnold] - Changed data bag encryption level to default to :no.

1.0.4 24-June-2014
-----
- [David Arnold] - Updated to support encrypted data bags.

1.0.3 19-June-2014
-----
- [David Arnold] - Initial release of nmdbase that includes ldap, sssd and yubico config.

- - -

# 0.1.0 07-April-2014

* Initial Release
  -  nmdbase::default
    -  Includes the fail2ban recipe.
    -  Configures this instance as an LDAP client.
    -  Configures this instance as an Yubico API client.
    -  Configures this instance as a chef client.
    -  Configures the chef-client service.
  -  nmdbase::ldap
    -  Installs the LDAP package to set this instance up as a client.
    -  Installs LDAP command line utilities.
    -  Configures the LDAP connection for this client.
    -  Installs the LDAP secret authentication content.
    -  Modifies the Name Service Switch to use LDAP.
    -  It configures the PAM common session to create users from LDAP.
  -  nmdbase::yubico
    -  Includes the openssh recipe.
    -  Installs the openssh-client.
    -  Installs the openssh-server.
    -  Enables the ssh service.
    -  Starts the ssh service.
    -  Creates the ssh configuration.
    -  Creates the sshd configuration.
    -  Installs python-software-properties.
    -  Adds the yubico repositories.
    -  Notifies apt-get update when adding yubico repositories.
    -  Installs the libpam-yubico package from the yubico repositories.
    -  Creates a global yubico auth file.
    -  Configures the sshd PAM module.
    -  Prepares for PAM debug logging.

