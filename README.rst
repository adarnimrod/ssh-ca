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

    ssh-ca newhost host.domain.tld

Deployment
----------

<placeholder>

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

- Test by starting sshd on localhost with a high port and connecting to it.
- Document deployment.
