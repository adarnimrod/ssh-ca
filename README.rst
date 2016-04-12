SSH-CA
######

This utility assists in creating an SSH certificate authority. It aims to be
production-ready and a secure solution for managing SSH key-pairs for both users
and hosts.

Installation
------------
.. code:: shell

    git clone https://www.shore.co.il/git/ssh-ca
    cd ssh-ca
    sudo make install

Usage
-----

To start a new certificate authority (creates an RSA keypair for signing
purposes and hosts and users directories)

.. code:: shell

    ssh-ca init

To sign a user's public key (found under users/<username>/id_*.pub)

.. code:: shell

    ssh-ca signuser username

To sign a host's public key (found under hosts/<hostname>/ssh_host_*.pub)

.. code:: shell

    ssh-ca signhost hostname

To generate a new keypair for a host with a signed public key

.. code:: shell

    ssh-ca newhost hostname

To generate a new keypair for a user with a signed public key

.. code:: shell

    ssh-ca newuser username

Authenticating hosts
--------------------

#. Sign the server's public key or generate a new pair and copy the files over.
#. Add the following line to :code:`/etc/ssh/sshd_config`::

    HostCertificate /path/to/the/signed/public/key

#. Add a line to your `known_hosts` file to authorize signed public keys to a
   specific top level domain. For example if your domain is example.com and the
   contents of :code:`CA.pub` is::

       ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2fAkeidfnPn712B4uW3XhKyFt9FcJtVwSPKDSCykULg3X5gVV/Xa1yb4ameY3ihXOqQOlG3YpYnOQ8KdM67WtnERVbTJIfieRjGzoURz9NquLFXSKsuQrXMWRNHqXAHw7VirPvKL4cSc4l00Az1HDnHhMIclPY8G+8SkRIRsTwwwa5QjGF2wuhC6j5UHJSaF7qLFw9FSaCsEJTkQxtCD4+Rd/dxv3kVWSkm5DbNG0z3QHyISW7XDvyXP+1ccSb5+IWC0yQCT4OJNFUMDb+SdD7AzDHfI9Z5zTp56uGV23lywWhSvv20UPA0SyXJNGPOw7uJ1ak8q4SBh60PtOENQf ssh-ca

Then the line will be::

    @cert-authority *.example.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2fAkeidfnPn712B4uW3XhKyFt9FcJtVwSPKDSCykULg3X5gVV/Xa1yb4ameY3ihXOqQOlG3YpYnOQ8KdM67WtnERVbTJIfieRjGzoURz9NquLFXSKsuQrXMWRNHqXAHw7VirPvKL4cSc4l00Az1HDnHhMIclPY8G+8SkRIRsTwwwa5QjGF2wuhC6j5UHJSaF7qLFw9FSaCsEJTkQxtCD4+Rd/dxv3kVWSkm5DbNG0z3QHyISW7XDvyXP+1ccSb5+IWC0yQCT4OJNFUMDb+SdD7AzDHfI9Z5zTp56uGV23lywWhSvv20UPA0SyXJNGPOw7uJ1ak8q4SBh60PtOENQf ssh-ca

#. You can also add it system wide by adding the above line to
:code:`/etc/ssh/ssh_known_hosts` and the following line to your
:code:`ssh_config` file::

    GlobalKnownHostsFile /etc/ssh/ssh_known_hosts

#. For strict security, add the following line to you `ssh_config` file::

    StrictHostKeyChecking yes

Authenticating users
--------------------

#. Sign the user's public key or generate a new pair and copy them over.
#. Copy :code:`CA.pub` over to the host.
#. Add the following line to :code:`/etc/ssh/sshd_config`::

    TrustedUserCAKeys /path/to/CA.pub

Development
-----------

To ease development :code:`make clean`, :code:`make lint` and :code:`make test`
are available. It's recommended to add :code:`make lint`  and :code:`make test`
to to your Git pre-commit and pre-push hooks accordingly. Also, this repo has
`pre-commit <http://pre-commit.com/>`_ configured.

License
-------

This software is licensed under the MIT license (see the :code:`LICENSE.txt`
file).

Author
------

Nimrod Adar, `contact me <nimrod@shore.co.il>`_ or visit my `website
<https://www.shore.co.il/>`_. Patches are welcome via `git send-email
<http://git-scm.com/book/en/v2/Git-Commands-Email>`_. The repository is located
at: https://www.shore.co.il/git/.

TODO
----

- Better, more thorough documentation.
