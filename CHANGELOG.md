# 0.1.0 07-April-2014

* Initial Release
  -  base::default
    -  Includes the fail2ban recipe.
    -  Configures this instance as an LDAP client.
    -  Configures this instance as an Yubico API client.
    -  Configures this instance as a chef client.
    -  Configures the chef-client service.
  -  base::ldap
    -  Installs the LDAP package to set this instance up as a client.
    -  Installs LDAP command line utilities.
    -  Configures the LDAP connection for this client.
    -  Installs the LDAP secret authentication content.
    -  Modifies the Name Service Switch to use LDAP.
    -  It configures the PAM common session to create users from LDAP.
  -  base::yubico
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

