SSH-CA
######

This utility assists in creating an SSH certificate authority. It aims to be
production-ready and a secure solution for managing SSH key-pairs for both users
and hosts.

Installation
------------
::

    git clone https://www.shore.co.il/cgit/ssh-ca
    cd ssh-ca
    sudo make install

Usage
-----

To start a new certificate authority::

    ssh-ca init

To sign a user's public key::

    ssh-ca signuser username

To sign a hosts's public key::

    ssh-ca signhost hostname

To generate a new keypair for a host with a signed public key::

    ssh-ca newhost hostname

To generate a new keypair for a user with a signed public key::

    ssh-ca newuser username

Authenticating hosts
--------------------

#. Sign the server's public key or generate a new pair and copy the files over.
#. Add the following line to `/etc/ssh/sshd_config`::

    HostCertificate /path/to/the/signed/public/key

#. Add a line to your `known_hosts` file to authorize signed public keys to a
specific top level domain. For example if your domain is example.com and the
contents of `CA.pub` is::

    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2fAkeidfnPn712B4uW3XhKyFt9FcJtVwSPKDSCykULg3X5gVV/Xa1yb4ameY3ihXOqQOlG3YpYnOQ8KdM67WtnERVbTJIfieRjGzoURz9NquLFXSKsuQrXMWRNHqXAHw7VirPvKL4cSc4l00Az1HDnHhMIclPY8G+8SkRIRsTwwwa5QjGF2wuhC6j5UHJSaF7qLFw9FSaCsEJTkQxtCD4+Rd/dxv3kVWSkm5DbNG0z3QHyISW7XDvyXP+1ccSb5+IWC0yQCT4OJNFUMDb+SdD7AzDHfI9Z5zTp56uGV23lywWhSvv20UPA0SyXJNGPOw7uJ1ak8q4SBh60PtOENQf ssh-ca

Then the line will be::

    @cert-authority *.example.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2fAkeidfnPn712B4uW3XhKyFt9FcJtVwSPKDSCykULg3X5gVV/Xa1yb4ameY3ihXOqQOlG3YpYnOQ8KdM67WtnERVbTJIfieRjGzoURz9NquLFXSKsuQrXMWRNHqXAHw7VirPvKL4cSc4l00Az1HDnHhMIclPY8G+8SkRIRsTwwwa5QjGF2wuhC6j5UHJSaF7qLFw9FSaCsEJTkQxtCD4+Rd/dxv3kVWSkm5DbNG0z3QHyISW7XDvyXP+1ccSb5+IWC0yQCT4OJNFUMDb+SdD7AzDHfI9Z5zTp56uGV23lywWhSvv20UPA0SyXJNGPOw7uJ1ak8q4SBh60PtOENQf ssh-ca

#. You can also add it system wide by adding the above line to
`/etc/ssh/ssh_known_hosts` and the following line to your `ssh_config` file::

    GlobalKnownHostsFile /etc/ssh/ssh_known_hosts

#. For strict security, add the following line to you `ssh_config` file::

    StrictHostKeyChecking yes

Authenticating users
--------------------

#. Sign the user's public key or generate a new pair and copy them over.
#. Copy CA.pub over to the host.
#. Add the following line to `/etc/ssh/sshd_config`::

    TrustedUserCAKeys /path/to/CA.pub

Development
-----------

To ease development ``make clean`` and ``make test`` are available. It's
recommended to add ``make test`` to your git pre-commit hook.

License
-------

This software is licnesed under the MIT licese (see the ``LICENSE.txt`` file).

Author
------

Nimrod Adar, `contact me <nimrod@shore.co.il>`_ or visit my `website
<https://www.shore.co.il/>`_. Patches are welcome via `git send-email
<http://git-scm.com/book/en/v2/Git-Commands-Email>`_. The repository is located
at: https://www.shore.co.il/cgit/.

TODO
----
