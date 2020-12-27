# SSH-CA

[![pipeline status](https://git.shore.co.il/nimrod/ssh-ca/badges/master/pipeline.svg)](https://git.shore.co.il/nimrod/ssh-ca/-/commits/master)

This utility assists in creating an SSH certificate authority. It aims
to be production-ready and a secure solution for managing SSH key-pairs
for both users and hosts.

## Installation

```shell
git clone https://www.shore.co.il/git/ssh-ca
cd ssh-ca
sudo make install
```

## Usage

To start a new certificate authority (creates an RSA keypair for signing
purposes and hosts and users directories)

```shell
ssh-ca init
```

To sign a user's public key (found under
users/\<username>/[id](<>)\*.pub)

```shell
ssh-ca signuser username
```

To sign a host's public key (found under
hosts/\<hostname>/[ssh\_host](<>)\*.pub)

```shell
ssh-ca signhost hostname
```

To generate a new keypair for a host with a signed public key

```shell
ssh-ca newhost hostname
```

To generate a new keypair for a user with a signed public key

```shell
ssh-ca newuser username
```

## Authenticating hosts

1. Sign the server's public key or generate a new pair and copy the
   files over.

1. Add the following line to `/etc/ssh/sshd_config`:

   ```
   HostCertificate /path/to/the/signed/public/key
   ```

1. Add a line to your known\_hosts file to authorize signed public keys
   to a specific top level domain. For example if your domain is
   example.com and the contents of `CA.pub` is:

   ```
   ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2fAkeidfnPn712B4uW3XhKyFt9FcJtVwSPKDSCykULg3X5gVV/Xa1yb4ameY3ihXOqQOlG3YpYnOQ8KdM67WtnERVbTJIfieRjGzoURz9NquLFXSKsuQrXMWRNHqXAHw7VirPvKL4cSc4l00Az1HDnHhMIclPY8G+8SkRIRsTwwwa5QjGF2wuhC6j5UHJSaF7qLFw9FSaCsEJTkQxtCD4+Rd/dxv3kVWSkm5DbNG0z3QHyISW7XDvyXP+1ccSb5+IWC0yQCT4OJNFUMDb+SdD7AzDHfI9Z5zTp56uGV23lywWhSvv20UPA0SyXJNGPOw7uJ1ak8q4SBh60PtOENQf ssh-ca
   ```

Then the line will be:

```
@cert-authority *.example.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2fAkeidfnPn712B4uW3XhKyFt9FcJtVwSPKDSCykULg3X5gVV/Xa1yb4ameY3ihXOqQOlG3YpYnOQ8KdM67WtnERVbTJIfieRjGzoURz9NquLFXSKsuQrXMWRNHqXAHw7VirPvKL4cSc4l00Az1HDnHhMIclPY8G+8SkRIRsTwwwa5QjGF2wuhC6j5UHJSaF7qLFw9FSaCsEJTkQxtCD4+Rd/dxv3kVWSkm5DbNG0z3QHyISW7XDvyXP+1ccSb5+IWC0yQCT4OJNFUMDb+SdD7AzDHfI9Z5zTp56uGV23lywWhSvv20UPA0SyXJNGPOw7uJ1ak8q4SBh60PtOENQf ssh-ca
```

\#. You can also add it system wide by adding the above line to
`/etc/ssh/ssh_known_hosts` and the following line to your
`ssh_config` file:

```
GlobalKnownHostsFile /etc/ssh/ssh_known_hosts
```

1. For strict security, add the following line to you ssh\_config file:

   ```
   StrictHostKeyChecking yes
   ```

## Authenticating users

1. Sign the user's public key or generate a new pair and copy them
   over.

1. Copy `CA.pub` over to the host.

1. Add the following line to `/etc/ssh/sshd_config`:

   ```
   TrustedUserCAKeys /path/to/CA.pub
   ```

## Development

For testing run `make test`}. For cleaning temporary files
run `git clean -fdx`. You can use
[pre-commit](http://pre-commit.com/) to have the test (which is quite
quick) run on every commit to ensure quality code.

## License

This software is licensed under the MIT license (see `LICENSE.txt`).

## Author Information

Nimrod Adar, [contact me](mailto:nimrod@shore.co.il) or visit my
[website](https://www.shore.co.il/). Patches are welcome via
[`git send-email`](http://git-scm.com/book/en/v2/Git-Commands-Email). The repository
is located at: <https://git.shore.co.il/expore/>.

## TODO

- Better, more thorough documentation.
